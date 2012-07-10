Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab2GJVlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 17:41:25 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:35579
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103Ab2GJVlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 17:41:24 -0400
X-Forefront-Antispam-Report: CIP:65.55.171.153;KIP:(null);UIP:(null);IPV:NLI;H:VA3DIAHUB038.RED001.local;RD:smtp801.microsoftonline.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I1432Izz1202hzz8275bhz2fh2a8h668h839h944hd25hf0ah107ah)
From: Scan Subscription <scan-subscription@coverity.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jul 2012 14:37:07 -0700
Subject: RE: [PATCH] kernel: fix mishandling of out of memory in poweroff
Thread-Topic: [PATCH] kernel: fix mishandling of out of memory in poweroff
Thread-Index: Ac1e2MOYuMZBOCv+Qm+pOP0c6LPh+AAC2PLh
Message-ID: <829BE905228AE14A9AE1A46E6F2E371605542A19B8@VA3DIAXVS891.RED001.local>
References: <20120704153443.4055.53130.stgit@bluebook>,<20120710131526.e64cf710.akpm@linux-foundation.org>
In-Reply-To: <20120710131526.e64cf710.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-OriginatorOrg: coverity.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6ALfUed025926

Hi Andew,

The two reports that were sent on 6/28 and 7/6, were sent manually by us, Coverit Scan Admin, project dedicated for Open Source Community.
But going forward (next week), it will be completely automated. 
Based on the suggestions we got from some of the lead Linux Developer, weekly report includes only "Newly" discovered defects from the code change in that week, and will be sent to maintainer and to the community.
There are on an avg. 5-10 new defects in a week, sometime none.

Any one who wants to contact the person for the reports being sent, they can use the details provided at the end of the email that is scan-admin@coverity.com 
However, we are open to suggestions.

Reasons for using generic email
1. It is desgined to be automated, but so far it was manuall.
2. There are group of people behind this email and not just one. So, anyone who is available will respond.
3. Other Open Source community has shown the same interest to generate report on newly discoverd defect every time build is commited to Scan, and we use the same generic email address to subscribe and to send the reoprt to their mailing list, instead of creating separate email for each Open Source project.

Hence, using either scan-admin@coverity.com or scan-subscription@coverity.com would be fine, but better would be to use the one in the email signaure, that is, scan-admin@coverity.com 
We will add "Reported By" in the next report.

However, as I said, we are open to suggestions.

Thanks
Coverity Scan-Admin scan-admin@coverity.com 
Dakshesh Vyas | Technical Manager - SCAN
Coverity | 185 Berry Street | Suite 6500, Lobby 3 | San Francisco, CA  94107 
Office: 415.935.2957 | dvyas@coverity.com
http://scan.coverity.com 

________________________________________
From: Andrew Morton [akpm@linux-foundation.org]
Sent: Tuesday, July 10, 2012 1:15 PM
To: Alan Cox
Cc: linux-kernel@vger.kernel.org; Scan Subscription
Subject: Re: [PATCH] kernel: fix mishandling of out of memory in poweroff

On Wed, 04 Jul 2012 16:34:51 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@linux.intel.com>
>
> Coverity 703573
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>

It would be nice to have a Reported-by here, but we were only given
"Scan Subscription <scan-subscription@coverity.com>".

Is there some human behind these reports?  If so, can that person's
details please be included?ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
