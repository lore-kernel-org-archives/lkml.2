Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab2A0Qkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:40:41 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:27170
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754504Ab2A0Qkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:40:40 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bh8275dhz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYGUBK-02-5D6-02
X-M-MSG: 
Date: Fri, 27 Jan 2012 17:40:29 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Brown <davidb@codeaurora.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH] iommu/msm: Fix error handling in msm_iommu_unmap()
Message-ID: <20120127164029.GQ19255@amd.com>
References: <1327598984-20662-1-git-send-email-joerg.roedel@amd.com>
 <20120127000630.GB16263@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120127000630.GB16263@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 04:06:30PM -0800, David Brown wrote:
> On Thu, Jan 26, 2012 at 06:29:44PM +0100, Joerg Roedel wrote:
> > Error handling in msm_iommu_unmap() is broken. On some error
> > conditions retval is set to a non-zero value which causes
> > the function to return 'len' at the end. This hides the
> > error from the user. Zero should be returned in those error
> > cases.
> > 
> > Cc: David Brown <davidb@codeaurora.org>
> > Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  drivers/iommu/msm_iommu.c |    7 +------
> >  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> Acked-by: David Brown <davidb@codeaurora.org>

Thanks. I'll queue this up with iommu fixes for 3.3 and mark it for
stable as well.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

