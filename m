Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab1ADKXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:23:30 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:3221 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1ADKX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:23:27 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zz98dNzz1202hzz15d4Rz32i637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEHU6S-01-GHE-02
X-M-MSG: 
Date: Tue, 4 Jan 2011 11:23:25 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Steffen Moser <lists@steffen-moser.de>
CC: Jeff Garzik <jeff@garzik.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: IOMMU and DMA mode of pata_jmicron
Message-ID: <20110104102325.GC2100@amd.com>
References: <4D1A7628.3050704@steffen-moser.de>
 <4D1A881C.3080109@garzik.org>
 <20110103112952.GA2100@amd.com>
 <4D222E7F.5080305@steffen-moser.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D222E7F.5080305@steffen-moser.de>
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

Hi Steffen,

On Mon, Jan 03, 2011 at 03:15:59PM -0500, Steffen Moser wrote:
> Beside a possible work-around, do you think, it makes sense to
> report the problem to ASUS as the straight way should be to have
> a correct IVRS table for the board?

Sure, that makes sense. Probably they fix their BIOS, but I wouldn't
count on it. But it is worth a try.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

