Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab1JJRjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:39:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab1JJRjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:39:14 -0400
Date: Mon, 10 Oct 2011 10:38:45 -0700
From: Greg KH <gregkh@suse.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-usb@vger.kernel.org,
        Harro Haan <hrhaan@gmail.com>, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] fix ehci alignment error
Message-ID: <20111010173845.GB25114@suse.de>
References: <20111010124154.464239811@gmail.com>
 <20111010141402.GA21856@suse.de>
 <yw1xipnwzu7a.fsf@unicorn.mansr.com>
 <20111010170042.GB24166@suse.de>
 <20115.11246.991917.639835@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20115.11246.991917.639835@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 07:31:26PM +0200, Mikael Pettersson wrote:
> Greg KH writes:
>  > On Mon, Oct 10, 2011 at 05:29:13PM +0100, Måns Rullgård wrote:
>  > > Greg KH <gregkh@suse.de> writes:
>  > > 
>  > > > On Mon, Oct 10, 2011 at 02:38:27PM +0200, Harro Haan wrote:
>  > > >> The Kirkwood gave an unaligned memory access error on
>  > > >> line 742 of drivers/usb/host/echi-hcd.c:
>  > > >> "ehci->last_periodic_enable = ktime_get_real();"
>  > > >
>  > > > What is "The Kirkwood"?  What size processor is this?
>  > > 
>  > > It's an ARM926-like CPU from Marvell.
>  > 
>  > 32 or 64bit?
> 
> All ARMs are 32-bit, but some have instructions for loading or
> storing 2 x 32 bits at a time, but also require the corresponding
> memory address to be 64-bit aligned.

Ah, ok, that makes more sense here.  I'll go queue it up.

greg k-h
