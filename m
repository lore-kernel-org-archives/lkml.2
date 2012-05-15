Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965580Ab2EOPxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:53:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758544Ab2EOPxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:53:13 -0400
Date: Tue, 15 May 2012 18:53:03 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hannes Reinecke <hare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515155303.GJ6948@redhat.com>
References: <20120515111255.GJ32036@redhat.com>
 <4FB23C09.7060300@suse.de>
 <20120515115917.GK32036@redhat.com>
 <20120515150015.5bf17aea@pyramind.ukuu.org.uk>
 <20120515143644.GD6948@redhat.com>
 <20120515155206.520e46b6@pyramind.ukuu.org.uk>
 <20120515145316.GF6948@redhat.com>
 <20120515162226.1b9a7496@pyramind.ukuu.org.uk>
 <20120515152942.GH6948@redhat.com>
 <20120515164143.3e8a8d04@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515164143.3e8a8d04@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 04:41:43PM +0100, Alan Cox wrote:
> > Hmm, will work if standard I/O addresses are used for master/slave, but
> > I do not see this information be exposed via /sys by EDD. So how can I
> > do it from OS installer with current kernel or kernel with reverted
> > patch?
> 
> I don't think we provide the needed info for this (or EDD 2.1 which I've
> just discovered actually shipped in some plug in boards). Not sure 2.1 is
> around online anywhere.
> 
> Thats a separate problem though.
> 
It is not. You are saying that the code we have now supported Phoenix
spec and now it is not. This is not the case though.

> My big concern is that we are sure it disappearing won't break anything.
> It's been noticed at SuSE so it's obviously not entiely invisible.
So lets ask Hannes what problem he tries to fix by the patch.

> 
> I'd love to see EDD 1.1 and 2.1 support in the kernel as I could then
> merge pata_hdd which drives original MFM/RLL drives. However I don't
> believe its worth the effort unlike doing 3.0 right.
> 
It is OK to add Phoenix support to the code. To do that code needs to
figure what spec BIOS uses and parse the data differently, not just blindly
misinterpret binary buffer.

--
			Gleb.
