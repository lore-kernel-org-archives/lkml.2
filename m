Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab1ETNEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:04:22 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:44831 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932176Ab1ETNEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:04:21 -0400
X-IronPort-AV: E=Sophos;i="4.65,242,1304287200"; 
   d="scan'208";a="95080228"
Date: Fri, 20 May 2011 15:04:17 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH]: Fix Ultrastor asm snippet
Message-ID: <20110520130417.GO5077@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Christoph Hellwig <hch@infradead.org>, James.Bottomley@suse.de,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	akpm@linux-foundation.org
References: <20110518150605.GA25262@const.bordeaux.inria.fr> <20110520130215.GB3428@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110520130215.GB3428@infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig, le Fri 20 May 2011 09:02:15 -0400, a écrit :
> On Wed, May 18, 2011 at 05:06:05PM +0200, Samuel Thibault wrote:
> > Commit 1292500b replaced
> > 
> > "=m" (*field) : "1" (*field)
> > 
> > with
> > 
> > "=m" (*field) :
> > 
> > with comment "The following patch fixes it by using the '+' operator on
> > the (*field) operand, marking it as read-write to gcc."
> > '+' was actually forgotten.  This really puts it.
> 
> Do you actually have the hardware or was this just a code audit?

Just a code audit.

> I have the strong suspicion that this driver is pretty much dead and
> bitrotting.

Most probably, yes.

Samuel
