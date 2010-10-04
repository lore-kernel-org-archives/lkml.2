Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab0JDONi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 10:13:38 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:48336
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751181Ab0JDONg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 10:13:36 -0400
X-SpamScore: -21
X-BigFish: VS-21(zz1432N98dNzz1202hzz15d4Rz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9RRH9-01-09W-02
X-M-MSG: 
Date: Mon, 4 Oct 2010 16:13:45 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] x86: Reenable the AMD IOMMU if it's mysteriously
 vanished over suspend
Message-ID: <20101004141345.GU9817@amd.com>
References: <1285941683-7445-1-git-send-email-mjg@redhat.com>
 <20101004134339.GT9817@amd.com>
 <20101004135552.GA5063@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101004135552.GA5063@srcf.ucam.org>
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

On Mon, Oct 04, 2010 at 09:55:52AM -0400, Matthew Garrett wrote:
> On Mon, Oct 04, 2010 at 03:43:39PM +0200, Roedel, Joerg wrote:
> > 
> > Why have you moved this out of the enable_iommus() loop?
> 
> enable_iommus() is called on init, whereas this should only be performed 
> on resume.

Ok, it shouldn't be problematic to do this always, but only on resume is
safer.  Can you rename iommu_apply_quirks to iommu_apply_resume_quirks
then?

> I'll send out an updated patch later today.

Great. Looking forward to it.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

