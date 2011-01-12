Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab1ALWzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:55:23 -0500
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:54480 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749Ab1ALWzW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:55:22 -0500
From: Rasesh Mody <rmody@brocade.com>
To: Joe Perches <joe@perches.com>, Debashis Dutt <ddutt@brocade.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 Jan 2011 14:55:25 -0800
Subject: RE: [PATCH 2/3] bna: Remove unnecessary memset(,0,)
Thread-Topic: [PATCH 2/3] bna: Remove unnecessary memset(,0,)
Thread-Index: Acuynql7PaK4CPBVR/Kz1JgImSutkwAC8pbw
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A5CFF6C4A8@HQ1-EXCH01.corp.brocade.com>
References: <6f6d4a7a705949a3464471f364f77215f1e796f3.1294867098.git.joe@perches.com>
 <0ed96bd1a053e61c827f2ac09e38cba59e32a21b.1294867098.git.joe@perches.com>
In-Reply-To: <0ed96bd1a053e61c827f2ac09e38cba59e32a21b.1294867098.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-01-12_05:2011-01-12,2011-01-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=1
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1101120147
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From: Joe Perches [mailto:joe@perches.com]
>Sent: Wednesday, January 12, 2011 1:21 PM
>
>kzalloc'd memory doesn't need a memset to 0.
>
>Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Rasesh Mody <rmody@brocade.com>

>---
> drivers/net/bna/bnad_ethtool.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/net/bna/bnad_ethtool.c
>b/drivers/net/bna/bnad_ethtool.c
>index 99be5ae..142d604 100644
>--- a/drivers/net/bna/bnad_ethtool.c
>+++ b/drivers/net/bna/bnad_ethtool.c
>@@ -275,7 +275,6 @@ bnad_get_drvinfo(struct net_device *netdev, struct
>ethtool_drvinfo *drvinfo)
>
> 	ioc_attr = kzalloc(sizeof(*ioc_attr), GFP_KERNEL);
> 	if (ioc_attr) {
>-		memset(ioc_attr, 0, sizeof(*ioc_attr));
> 		spin_lock_irqsave(&bnad->bna_lock, flags);
> 		bfa_nw_ioc_get_attr(&bnad->bna.device.ioc, ioc_attr);
> 		spin_unlock_irqrestore(&bnad->bna_lock, flags);
>--
>1.7.3.3.398.g0b0cd.dirty

Joe,
Patch looks ok to me.
Thanks,
Rasesh
