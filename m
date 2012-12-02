Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2LBPMB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 10:12:01 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:44781 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914Ab2LBPL6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 10:11:58 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dIzz1de0h1202h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631hbe9i1155h)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: Sethi Varun-B16395 <B16395@freescale.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Tabi Timur-B04825 <B04825@freescale.com>
Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
Thread-Topic: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
Thread-Index: AQHNxydj5NZPSTDOR0u3Ec8nKfkMZZgFnUaAgAATHQA=
Date: Sun, 2 Dec 2012 15:11:54 +0000
Message-ID: <6AE080B68D46FC4BA2D2769E68D765B7081BD902@039-SN2MPN1-023.039d.mgd.msft.net>
References: <1353419697-31269-1-git-send-email-Varun.Sethi@freescale.com>
 <1353419697-31269-4-git-send-email-Varun.Sethi@freescale.com>
 <20121202140323.GO30633@8bytes.org>
In-Reply-To: <20121202140323.GO30633@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/17.0
 Firefox/17.0 SeaMonkey/2.14
x-originating-ip: [70.112.99.80]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <B9AA00DCAD5BDB4BA4F903AE35466973@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> When you add implementation specific attributes please add some
> indication to the names that it is only for PAMU. DOMAIN_ATTR_STASH
> sounds too generic.

We were thinking that maybe this attribute could be useful to other IOMMUs 
in the future.  Stashing is not a concept that would only work on 
Freescale processors.

But we'll change it if you insist.

-- 
Timur Tabi
Linux kernel developer at Freescale
