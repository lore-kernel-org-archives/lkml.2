Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab2GCQDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 12:03:01 -0400
Received: from outbound04.telus.net ([199.185.220.223]:46048 "EHLO
	defout.telus.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755246Ab2GCQDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 12:03:00 -0400
X-Authority-Analysis: v=1.1 cv=y4SEATtu4Z/GL8+sjzCNMczfEX7PYCOhlmsyhTH4Koc=
 c=1 sm=2 a=d5aLr75umSEA:10 a=LGgl8L9ij00A:10 a=ZPSk82zQDygA:10
 a=FGbulvE0AAAA:8 a=2QBuMR3QyN3kyrAmzQcA:9 a=UAVRJdkkkM0A:10 a=q8WS6ZIQ5gMA:10
 a=bfXEvA2ThEX4vjLN:21 a=snL0Wr3dd8KPZiz4:21
X-Telus-Outbound-IP: 173.180.45.4
From: "Doug Smythies" <dsmythies@telus.net>
To: "'Peter Zijlstra'" <peterz@infradead.org>
Cc: "'Yong Zhang'" <yong.zhang0@gmail.com>,
        "'Charles Wang'" <muming.wq@gmail.com>, <linux-kernel@vger.kernel.org>,
        "'Ingo Molnar'" <mingo@redhat.com>, "'Tao Ma'" <tm@tao.ma>,
        =?iso-2022-jp?B?JxskQjReQmMbKEIn?= <handai.szj@taobao.com>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Doug Smythies'" <dsmythies@telus.net>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>			 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>			 <1339494970.31548.66.camel@twins> <4FDB4642.5070509@gmail.com>			 <1340035417.15222.95.camel@twins> <20120619060824.GA31684@zhy>		 <1340097532.21745.19.camel@twins> <000001cd4e33$496f6c30$dc4e4490$@net>	 <1340185528.21745.86.camel@twins> <002301cd4f64$17a055c0$46e10140$@net> <1340373782.18025.74.camel@twins> <000001cd5252$b47d2a30$1d777e90$@net>
In-Reply-To: <000001cd5252$b47d2a30$1d777e90$@net>
Subject: RE: [PATCH] sched: Folding nohz load accounting more accurate
Date: Tue, 3 Jul 2012 09:01:36 -0700
Message-ID: <000701cd5935$43eebab0$cbcc3010$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac1Qf8Y0dgtIxj9RSkGmYoFffmvwKgB0AwSAAbj9NOA=
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> On 2012.06.22 07:03 -0700, Peter Zijlstra wrote:
>  On 2012.06.24 14:46 -0700, Doug Smythies wrote:

>> Doug, Charles,

>> Can you both confirm that the below patch is what you tested and we
>> should finally be able to close this issue?

> [... patch code deleted ...]

> Yes, I confirm that is the patch code I am testing, back edited to my
> working environment (So far, I call this "peter35").

> Some more test results are attached as PNG files and tests will
> continue for at least another couple of days. I can comment
> further on the "finally close this issue" question then, but it
> looks very good so far.

> Unless I find some issue, I won't push further results to this list,
> But results can be pulled from [1].

> [1] http://www.smythies.com/~doug/network/load_average/peter35.html

I have finished my testing of Peter's proposed patch (my reference:
"peter35")
I don't claim that the testing was exhaustive, but I do claim that it was
pretty thorough.

Yes, In my opinion, we can finally close this issue.
Thanks.



