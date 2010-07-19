Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab0GSNnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 09:43:22 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:44030
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932391Ab0GSNnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 09:43:20 -0400
X-SpamScore: -25
X-BigFish: VPS-25(z21eRz98dNzz1202hzz15d4Rz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5T4RU-01-GMX-02
X-M-MSG: 
Date: Mon, 19 Jul 2010 15:44:54 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Tom Lyon <pugs@cisco.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "aafabbri@cisco.com" <aafabbri@cisco.com>,
        "scofeldm@cisco.com" <scofeldm@cisco.com>
Subject: Re: [PATCH V3] 2.6.34: simple IOMMU API extension to check safe
 interrupt remapping
Message-ID: <20100719134453.GD7454@amd.com>
References: <4c2e526e.HXT+zIj7fSMwTdy/%pugs@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4c2e526e.HXT+zIj7fSMwTdy/%pugs@cisco.com>
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

On Fri, Jul 02, 2010 at 04:56:14PM -0400, Tom Lyon wrote:
> This patch allows IOMMU users to determine whether the hardware and software
> support safe, isolated interrupt remapping.  Not all Intel IOMMUs have the
> hardware, and the software for AMD is not there yet.
> 	Signed-off-by: Tom Lyon <pugs@cisco.com>

Applied, thanks.

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

