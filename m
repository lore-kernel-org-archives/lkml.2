Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab0FUUsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:48:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab0FUUsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:48:00 -0400
Date: Mon, 21 Jun 2010 16:46:46 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Add TAINT_HARDWARE_UNSUPPORTED flag
Message-ID: <20100621204646.GJ3217@redhat.com>
References: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com>
 <20100617091322.b7d21473.randy.dunlap@oracle.com>
 <4C1A7D61.8010900@redhat.com>
 <20100621122145.76ebd7ac.akpm@linux-foundation.org>
 <20100621194559.GI3217@redhat.com>
 <20100621130008.d3dc01a8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621130008.d3dc01a8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 01:00:08PM -0700, Andrew Morton wrote:
> > Internally here that is how we planned on using the flag.  We weren't sure
> > if upstream would accept that piece or not, so we started with the flag
> > for now to at least reserve the bit.
> > 
> > But I can see your point about the other printk being a little
> > user-hostile if someone forgot to call the wrapper function.
> > 
> > I can respin with the wrapper function (Prarit is on vacation)
> 
> Not telling the user _which_ hardware is causing the problem is daft.
> 
> > or go with
> > Alan's idea of just reserving the upper few bits.
> 
> um.  Given that the vendor needs to patch the individual drivers to
> indicate ther unsupported status, why not just patch in the taint
> changes as well?

Well we wanted to secure a bit flag first, so we don't bite ourselves later and
have to change the userspace tools.

Cheers,
Don
