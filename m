Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab1FNJaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:30:52 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:26017
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755467Ab1FNJau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:30:50 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4R8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMRX38-02-9F4-02
X-M-MSG: 
Date: Tue, 14 Jun 2011 11:31:16 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Laura Abbott <lauraa@codeaurora.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Tom Lyon <pugs@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iommu-api: Add missing header file
Message-ID: <20110614093115.GE29908@amd.com>
References: <1307568552-9239-1-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1307568552-9239-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 05:29:11PM -0400, Laura Abbott wrote:
> If CONFIG_IOMMU_API is not defined some functions will just
> return -ENODEV. Add errno.h for the definition of ENODEV.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Applied, thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

