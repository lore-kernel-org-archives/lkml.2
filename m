Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1KCBTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:19:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49394 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474Ab1KCBTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:19:35 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Nov 2011 21:19:35 EDT
Message-ID: <4EB1E964.7030906@fb.com>
Date: Wed, 2 Nov 2011 18:07:48 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andrew Vagin <avagin@openvz.org>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, <devel@openvz.org>
Subject: Re: [PATCH 4/4] perf: add scripts for profiling sleep times
References: <1320274784-2463901-1-git-send-email-avagin@openvz.org> <1320274784-2463901-5-git-send-email-avagin@openvz.org>
In-Reply-To: <1320274784-2463901-5-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-11-02_06:2011-11-03,2011-11-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/11 3:59 PM, Andrew Vagin wrote:
> +perf record -ag -e sched:sched_switch --filter "prev_state == 1 || prev_state == 2" -e sched:sched_process_exit ${@/--/}

Like I said on the other thread: it'd be good to have this feature 
available to normal users without requiring root or
perf_event_paranoid <= 0.

But having it available to root users would be a good first step. Thanks 
for doing this work.

  -Arun
