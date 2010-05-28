Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab0E1HL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:11:27 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:32461 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0E1HLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:11:24 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz119bM1432P98dNzz1202hzzz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L34BYO-02-PY8-02
X-M-MSG: 
Date: Fri, 28 May 2010 09:11:15 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Nicolas Palix <npalix@diku.dk>
CC: Julia Lawall <julia@diku.dk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 6/17] arch/x86/kernel: Add missing spin_unlock
Message-ID: <20100528071114.GA3266@amd.com>
References: <Pine.LNX.4.64.1005261755260.23743@ask.diku.dk>
 <20100527111136.GV3266@amd.com>
 <Pine.LNX.4.64.1005271317180.5422@ask.diku.dk>
 <201005271342.25619.npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201005271342.25619.npalix@diku.dk>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:42:25AM -0400, Nicolas Palix wrote:
> > We have submitted and received some feedback on an initial version of 
> > this, but I'm not completely sure of the current status.
> 
> You can see the latest feedback we get at
> http://lkml.org/lkml/2010/5/10/257
> 
> The initial submission and its comments are at
> http://lkml.org/lkml/2010/4/26/269

I've also sent some feedback. Would be cool if you could work the
feedback in and do a repost asking Andrew to take it. Would be cool to
have this merged with 2.6.36.

	Joerg


