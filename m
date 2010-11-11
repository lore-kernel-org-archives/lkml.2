Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab0KKONL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:13:11 -0500
Received: from kroah.org ([198.145.64.141]:33470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab0KKONJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:13:09 -0500
Date: Thu, 11 Nov 2010 06:13:58 -0800
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Borislav Petkov <bp@amd64.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Hugh Dickins <hughd@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT
	trampoline
Message-ID: <20101111141358.GA4641@kroah.com>
References: <20101022162038.GA10343@kroah.com> <1289483775-17632-3-git-send-email-joerg.roedel@amd.com> <20101111141130.GB4323@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111141130.GB4323@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 06:11:30AM -0800, Greg KH wrote:
> On Thu, Nov 11, 2010 at 02:56:14PM +0100, Joerg Roedel wrote:
> > From: Hugh Dickins <hughd@google.com>
> > 
> > rc2 kernel crashes when booting second cpu on this CONFIG_VMSPLIT_2G_OPT
> > laptop: whereas cloning from kernel to low mappings pgd range does need
> > to limit by both KERNEL_PGD_PTRS and KERNEL_PGD_BOUNDARY, cloning kernel
> > pgd range itself must not be limited by the smaller KERNEL_PGD_BOUNDARY.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > LKML-Reference: <alpine.LSU.2.00.1008242235120.2515@sister.anvils>
> > Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> > ---
> >  arch/x86/kernel/trampoline.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> Why are you sending this to me?  I'm not the x86 maintainer.

Ah, now it makes more sense (seeing 0/3 after 2/3 came in.)

But, for all 3 of these patches, can you please resend them with the git
commit id of the original patch that is in Linus's tree?  I need that to
be able to apply them to the stable releases.

thanks,

greg k-h
