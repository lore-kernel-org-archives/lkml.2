Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2HCOKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:10:08 -0400
Received: from [216.32.180.189] ([216.32.180.189]:34693 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752769Ab2HCOKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:10:05 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI1432I4015Izz1202hzz15d4Iz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M86NA2-01-5WO-02
X-M-MSG: 
Date: Fri, 3 Aug 2012 16:08:26 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] iommu: Include linux/notifier.h
Message-ID: <20120803140826.GF1996@amd.com>
References: <1343226290-32511-1-git-send-email-thierry.reding@avionic-design.de>
 <1343226290-32511-2-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1343226290-32511-2-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 04:24:50PM +0200, Thierry Reding wrote:
> The linux/iommu.h header uses types defined in linux/notifier.h but
> doesn't include it.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Better than adding the header-file is to add a forward declaration for
struct notifier_block. I added a patch to iommu/fixes for this.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

