Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0KKOPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:15:52 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:15934 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0KKOPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:15:51 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zz1432N98dNzz1202hzz8275bh15d4Rz32i2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3extmailp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LBQ4XO-02-BV1-02
X-M-MSG: 
Date: Thu, 11 Nov 2010 15:17:33 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Greg KH <greg@kroah.com>
CC: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        Hugh Dickins <hughd@google.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT
 trampoline
Message-ID: <20101111141733.GP8917@amd.com>
References: <20101022162038.GA10343@kroah.com>
 <1289483775-17632-3-git-send-email-joerg.roedel@amd.com>
 <20101111141130.GB4323@kroah.com>
 <20101111141358.GA4641@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101111141358.GA4641@kroah.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 09:13:58AM -0500, Greg KH wrote:
> On Thu, Nov 11, 2010 at 06:11:30AM -0800, Greg KH wrote:
> > On Thu, Nov 11, 2010 at 02:56:14PM +0100, Joerg Roedel wrote:
> > > From: Hugh Dickins <hughd@google.com>
> > > 
> > > rc2 kernel crashes when booting second cpu on this CONFIG_VMSPLIT_2G_OPT
> > > laptop: whereas cloning from kernel to low mappings pgd range does need
> > > to limit by both KERNEL_PGD_PTRS and KERNEL_PGD_BOUNDARY, cloning kernel
> > > pgd range itself must not be limited by the smaller KERNEL_PGD_BOUNDARY.
> > > 
> > > Signed-off-by: Hugh Dickins <hughd@google.com>
> > > LKML-Reference: <alpine.LSU.2.00.1008242235120.2515@sister.anvils>
> > > Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> > > ---
> > >  arch/x86/kernel/trampoline.c |    3 +--
> > >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > Why are you sending this to me?  I'm not the x86 maintainer.
> 
> Ah, now it makes more sense (seeing 0/3 after 2/3 came in.)
> 
> But, for all 3 of these patches, can you please resend them with the git
> commit id of the original patch that is in Linus's tree?  I need that to
> be able to apply them to the stable releases.

Hey, you work very early in the morning :-)

I will add the upstream-commit-ids and repost.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

