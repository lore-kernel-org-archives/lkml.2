Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2HFRlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:41:15 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:51922
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685Ab2HFRlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:41:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIzz1202hzz15d4Iz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M8CH4I-02-4Q4-02
X-M-MSG: 
Date: Mon, 6 Aug 2012 19:41:13 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <dwmw2@infradead.org>, <iommu@lists.linux-foundation.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dsahern@gmail.com>
Subject: Re: [PATCH 0/2] Fix ACS path checking
Message-ID: <20120806174113.GM1996@amd.com>
References: <20120804180155.6144.83332.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120804180155.6144.83332.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 12:08:46PM -0600, Alex Williamson wrote:
> Alex Williamson (2):
>       amd-iommu: Fix ACS path checking
>       intel-iommu: Fix ACS path checking

Applied these two patches together with my ACS fix to iommu/fixes,
thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

