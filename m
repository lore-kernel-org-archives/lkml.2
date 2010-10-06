Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab0JFKHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 06:07:05 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:19972
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010Ab0JFKHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 06:07:03 -0400
X-SpamScore: -21
X-BigFish: VS-21(zz1432N98dNzz1202hzz8275bh8275dh15d4Rz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9V5EO-02-447-02
X-M-MSG: 
Date: Wed, 6 Oct 2010 12:07:35 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Matthew Garrett <mjg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH v2] x86: Reenable the AMD IOMMU if it's mysteriously
 vanished over suspend
Message-ID: <20101006100734.GX9817@amd.com>
References: <20101004134339.GT9817@amd.com>
 <1286218771-5934-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1286218771-5934-1-git-send-email-mjg@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 02:59:31PM -0400, Matthew Garrett wrote:
> AMD's reference BIOS code had a bug that could result in the firmware
> failing to reenable the iommu on resume. It transpires that this causes
> certain less than desirable behaviour when it comes to PCI accesses, to
> whit them ending up somewhere near Bristol when the more desirable outcome
> was Edinburgh. Sadness ensues, perhaps along with filesystem corruption.
> Let's make sure that it gets turned back on, and that we restore its
> configuration so decisions it makes bear some resemblance to those made by
> reasonable people rather than crack-addled lemurs who spent all your DMA
> on Thunderbird.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Cc: stable@kernel.org

Applied, thanks a lot.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

