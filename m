Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0HBTxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:53:36 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:51613 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab0HBTxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:53:34 -0400
Date: Mon, 2 Aug 2010 15:52:48 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek <konrad@hera.kernel.org>, torvalds@linux-foundation.org,
        James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
        pjones@redhat.com, lenb@kernel.org, michaelc@cs.wisc.edu
Subject: Re: [GIT PULL] iBFT features for v2.6.36
Message-ID: <20100802195248.GB32503@andromeda.dapyr.net>
References: <20100802143642.GA15428@hera.kernel.org> <4C570CDD.5070304@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C570CDD.5070304@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 11:22:21AM -0700, H. Peter Anvin wrote:
> On 08/02/2010 07:36 AM, Konrad Rzeszutek wrote:
> > What is iBFT?
> > The iBFT is an equivalent to the Boot Flag, except that its geared
> > towards iSCSI and hence requires much more information (such as
> > the IP of target, passwords, which device to login, etc). iBFT
> > is a data structure populated by the BIOS or the NIC to contain this
> > so that the OS can read it and login to the iSCSI and present
> > the boot device to the initrd for mounting / FS.
> 
> I really don't see iBFT as equivalent to the boot flag at all.  The boot

I think for somebody who might confuse iBFT with a bar of soap
the "equivalant" will put them in the right frame of mind. And yes
it is not equivalant at all, should have said something like 'remotely akin' :-)

> flag returns the status of the previous boot attempt; iBFT contains
> information about where to find the current root.
> 
> Unfortunately, we're increasingly seeing a proliferation of this kind of
> nonstandard ACPI tables, because it is difficult to add data to ACPI at

Keep in mind that iBFT is now a standard (woot!)

> runtime.  gPXE creates an aBFT table for AoE and sBFT for SRP, and
> memdisk uses mBFT for MEMDISK at the moment.

Oh man, didn't know those existed at all.
> 
> It would be good to have some kind of common structure framework for these.

I need to grok those tables some more to figure out what they all do.
