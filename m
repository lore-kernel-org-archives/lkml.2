Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935133Ab2JXP2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:28:42 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:27568
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934874Ab2JXP2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:28:41 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z551biz98dI1454Izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah107ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14afh1504h1537h153bh1155h)
X-WSS-ID: 0MCELNO-01-383-02
X-M-MSG: 
Date: Wed, 24 Oct 2012 17:28:34 +0200
From: Joerg Roedel <Joerg.Roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <florian@dazinger.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] amd_iommu: Refactor IOMMU group and support
 virtual aliases
Message-ID: <20121024152834.GD2764@amd.com>
References: <20121009044057.16302.44577.stgit@bling.home>
 <1350595750.2112.438.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1350595750.2112.438.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 03:29:10PM -0600, Alex Williamson wrote:
> I think this series is good-to-go, modulo any testing you may be able to
> do on it.  I'm going to be offline for a couple weeks so feel free to
> incorporate this RFC directly or I can re-spin something when I'm back.

Okay, I applied the patches and will do some testing before pushing them
out. I will fix all objections by follow-on patches.


	Joerg


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

