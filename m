Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2JPMfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:35:24 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:43719
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862Ab2JPMfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:35:22 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14afh1155h)
X-WSS-ID: 0MBZKAO-01-FQB-02
X-M-MSG: 
Date: Tue, 16 Oct 2012 14:35:16 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] iommu: tegra: remove include of <mach/iomap.h>
Message-ID: <20121016123516.GB10997@amd.com>
References: <1349216149-858-1-git-send-email-swarren@wwwdotorg.org>
 <507C4B14.4070809@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <507C4B14.4070809@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Oct 15, 2012 at 11:42:44AM -0600, Stephen Warren wrote:

> Joerg, given 3.7-rc1 is now out, I'd like to take this through the Tegra
> tree due to other patches depending on it.
> 
> Given the patch is so trivial, I'll probably just apply it anyway soon -
> this is more of a heads-up to avoid it being taken through the IOMMU tree.

I will start merging patches soon. This one is already on my list :)


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

