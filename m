Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab2HZRxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 13:53:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33983 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751087Ab2HZRxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 13:53:38 -0400
Message-ID: <503A6273.9090702@fb.com>
Date: Sun, 26 Aug 2012 10:52:51 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Ulrich Drepper <drepper@gmail.com>
Subject: Re: perf backtraces off-by-1
References: <5037FC9F.3090603@fb.com> <1345997415.2296.0.camel@laptop>
In-Reply-To: <1345997415.2296.0.camel@laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.428,0.0.0000
 definitions=2012-08-26_07:2012-08-24,2012-08-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 8/26/12 9:10 AM, Peter Zijlstra wrote:
> On Fri, 2012-08-24 at 15:13 -0700, Arun Sharma wrote:
>
>>   One option is to support
>> this for user mode only, with code to detect signal frames. Any other
>> ideas?
>>
> I guess we'd need to see what that patch would look like... :-)
>

It used to look like this:

http://git.savannah.gnu.org/gitweb/?p=libunwind.git;a=commitdiff;h=92cc7fd78a5a79c4bb5f85bfb7d7fb025df9cd5a

These days we just look at dwarf augmentation string:

http://git.savannah.gnu.org/gitweb/?p=libunwind.git;a=blob;f=src/dwarf/Gfde.c;h=8659624b0320c514057861a259b6efe1b605bbf3;hb=HEAD#l189

  -Arun
