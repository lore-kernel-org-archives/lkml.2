Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1JJRMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:12:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab1JJRMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:12:09 -0400
Date: Mon, 10 Oct 2011 10:00:42 -0700
From: Greg KH <gregkh@suse.de>
To: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: Harro Haan <hrhaan@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        Nicolas Pitre <nico@fluxnic.net>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix ehci alignment error
Message-ID: <20111010170042.GB24166@suse.de>
References: <20111010124154.464239811@gmail.com>
 <20111010141402.GA21856@suse.de>
 <yw1xipnwzu7a.fsf@unicorn.mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yw1xipnwzu7a.fsf@unicorn.mansr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 05:29:13PM +0100, Måns Rullgård wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Mon, Oct 10, 2011 at 02:38:27PM +0200, Harro Haan wrote:
> >> The Kirkwood gave an unaligned memory access error on
> >> line 742 of drivers/usb/host/echi-hcd.c:
> >> "ehci->last_periodic_enable = ktime_get_real();"
> >
> > What is "The Kirkwood"?  What size processor is this?
> 
> It's an ARM926-like CPU from Marvell.

32 or 64bit?
