Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab1K2WfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 17:35:25 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:53003 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab1K2WfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 17:35:22 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "kobayashi.kk@ncos.nec.co.jp" <kobayashi.kk@ncos.nec.co.jp>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Tue, 29 Nov 2011 17:34:45 -0500
Subject: RE: [PATCH 0/4] delayacct: save max CPU/IO/SWAP/RECLAIM delays
Thread-Topic: [PATCH 0/4] delayacct: save max CPU/IO/SWAP/RECLAIM delays
Thread-Index: AcyueKDzLBYZ8yqcSEWqaLQ/u+SCywAbj7Hw
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB5816C48@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB574E70D@USINDEVS02.corp.hds.com>
 <1322558612.2921.182.camel@twins>
In-Reply-To: <1322558612.2921.182.camel@twins>
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
 definitions=main-1111290219
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pATMZX5I010472

On 11/29/2011 04:23 AM, Peter Zijlstra wrote:
> On Mon, 2011-11-28 at 17:44 -0500, Satoru Moriya wrote:
>> In the latency sensitive systems, we usually focus on the worst latency.
>> And so, it is useful to save max delays into the per-task delay 
>> accounting functionality.
>>
> 
> No!!!
> 
> Linus told us to be bastards, so there you have it.
> 
> There's way too many different accounting crap thingies around. And 
> now I get a patch without any justification what so ever. So no, piss off.

I agree that there are other ways to get max latency.

I think that with delayacct we can easily get delay statistics
which each task or task-group encountered in their life time
because delayacct records "per-task" delay.

But I just may not know better tools/functions.

Do you think which tools/functions is the best one (to extend)?
ftrace? perf?

Regards,
Satoru
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
