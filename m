Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab2ALBFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 20:05:44 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50183 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab2ALBFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 20:05:43 -0500
X-AuditID: 9c93016f-b7c72ae000007401-8d-4f0e31d9e088
Message-ID: <4F0E31D9.3080306@lge.com>
Date: Thu, 12 Jan 2012 10:05:29 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Namhyung Kim <namhyung@gmail.com>, axboe@kernel.dk, mingo@redhat.com,
        rostedt@goodmis.org, fweisbec@gmail.com, teravest@google.com,
        slavapestov@google.com, ctalbott@google.com, dhsharp@google.com,
        linux-kernel@vger.kernel.org, winget@google.com,
        Chanho Park <chanho61.park@samsung.com>
Subject: Re: [PATCH RESEND 9/9] block, trace: implement ioblame - IO tracer
 with origin tracking
References: <1326220106-5765-1-git-send-email-tj@kernel.org> <1326220106-5765-10-git-send-email-tj@kernel.org> <20120111013212.GA6843@dhcp-172-17-108-109.mtv.corp.google.com> <4F0D291A.8030205@lge.com> <20120111170635.GE26832@google.com>
In-Reply-To: <20120111170635.GE26832@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-01-12 2:06 AM, Tejun Heo wrote:
> Hello,
>
> On Wed, Jan 11, 2012 at 03:15:54PM +0900, Namhyung Kim wrote:
>> How about adding another tracepoint for intent creation to provide
>> raw data as well, somewhere in iob_get_intent() or
>> iob_intent_create() maybe? It can be useful to get those data for
>> further processing IMHO.
>
> While I don't particularly object to that, information and
> notification (via inotify) for that is already available via
> ioblame/intents file which we need regardless of the new tracepoint,
> so it's kinda redundant, isn't it?
>
> Thanks.
>

Yes. But that's a text-based so it might fit better to simple use cases. 
If we need further post processing based on intents, it could be better 
off having binary interface IMHO. And since we already use tracepoints 
anyway, wouldn't it be good to avoid adding another layer of interface 
or complexity?

Thanks,
Namhyung Kim
