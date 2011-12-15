Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003Ab1LOQDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:03:36 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:46813 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758954Ab1LOQDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:03:34 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Huang Ying <ying.huang@intel.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, "Chen, Gong" <gong.chen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Thu, 15 Dec 2011 11:03:08 -0500
Subject: RE: [RFC][PATCH]ACPI,APEI,ERST, back end driver for NVRAM
Thread-Topic: [RFC][PATCH]ACPI,APEI,ERST, back end driver for NVRAM
Thread-Index: Acyn5qSv46wNSz2jS5SRRlmMJb9yYATWtnXA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57F7ADB5@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57AC8046@USINDEVS01.corp.hds.com>
	 <1321581563.13860.111.camel@yhuang-dev>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C57B4FA66@USINDEVS01.corp.hds.com>
 <1321836227.13860.121.camel@yhuang-dev>
In-Reply-To: <1321836227.13860.121.camel@yhuang-dev>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1112150138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBFG3eOH009914

Hi,

>
>No.  I have different understanding.
>
>Because error log address range resides in NVRAM, the contents will be
>reserved even after reboot.  So we do not need read/clear operations at
>all, and should place all records in error log address range.

I have a quick question about your comment above.
Do you know whether this optimization of read/clear operations works 
on machines which APEI is enabled by WHEA _OSC call?

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
