Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab0G2J6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:58:37 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:1848 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab0G2J6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:58:35 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432N98dNzz1202hzz15d4Rz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6BD1D-02-6AH-02
X-M-MSG: 
Date: Thu, 29 Jul 2010 12:01:09 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100729100108.GQ26098@amd.com>
References: <20100729090607.GN26098@amd.com>
 <20100729181412H.fujita.tomonori@lab.ntt.co.jp>
 <20100729092821.GP26098@amd.com>
 <20100729184336N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100729184336N.fujita.tomonori@lab.ntt.co.jp>
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

On Thu, Jul 29, 2010 at 05:44:13AM -0400, FUJITA Tomonori wrote:
> On Thu, 29 Jul 2010 11:28:21 +0200
> "Roedel, Joerg" <Joerg.Roedel@amd.com> wrote:
> 
> > On Thu, Jul 29, 2010 at 05:14:49AM -0400, FUJITA Tomonori wrote:
> > > Well, the reason (nobody has tried) might be that linux/iommu.h
> > > doesn't look something intended for the generic IOMMU-API.
> > 
> > Oh, and as an additional note, the reason might also be that people were
> > not aware of its existence :-)
> 
> No. People actually read it and think that it's not intended for
> generic purposes, i.e., it was designed for VT-d/AMD-IOMMU with KVM:
> 
> http://lkml.org/lkml/2010/7/28/470

This states the as-is situation. There is not a single sentence that
states why the iommu-api can't be extended to fit their needs. Nobody
has ever written me an email about this to discuss this possibility.

> You designed it for what you need at the time. It should have been
> named appropriately to avoid confusion. Later, when we actually
> understand what other IOMMUs need, we can evolve the specific API for
> generic purposes. Then we can rename the API to more generic.

At the time the iommu-api was written is was generic enough for what we
had. So it was designed as an generic API. At this point in time nobody
knew what the future requirements would we. So today it turns out that
it is not generic enough anymore for latest hardware. The logical
consequence is to fix this in the iommu-api.

		Joerg

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

