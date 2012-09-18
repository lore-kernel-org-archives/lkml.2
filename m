Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab2IRKoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:44:44 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:21585
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756633Ab2IRKon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:44:43 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz6d524h17326ah15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAJKIA-01-7YB-02
X-M-MSG: 
Date: Tue, 18 Sep 2012 12:44:26 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <yongjun_wei@trendmicro.com.cn>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iommu/exynos: use list_del_init instead of
 list_del/INIT_LIST_HEAD
Message-ID: <20120918104426.GI2505@amd.com>
References: <CAPgLHd-QRgrRMCab-Co=dU9a524KGU12LKcRape4hVfiYgRxAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPgLHd-QRgrRMCab-Co=dU9a524KGU12LKcRape4hVfiYgRxAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 12:34:09PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using list_del_init() instead of list_del() + INIT_LIST_HEAD().
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied, thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

