Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2H1ReI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:34:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60717 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751167Ab2H1ReG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:34:06 -0400
Message-ID: <503D00D1.9070308@fb.com>
Date: Tue, 28 Aug 2012 10:33:05 -0700
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
References: <5037FC9F.3090603@fb.com> <1345997415.2296.0.camel@laptop>  <503A6273.9090702@fb.com> <1346171643.2296.8.camel@laptop>
In-Reply-To: <1346171643.2296.8.camel@laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.254]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-08-28_06:2012-08-28,2012-08-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/12 9:34 AM, Peter Zijlstra wrote:
>> It used to look like this:
>>
>> http://git.savannah.gnu.org/gitweb/?p=libunwind.git;a=commitdiff;h=92cc7fd78a5a79c4bb5f85bfb7d7fb025df9cd5a
>
> Hmm, that's not too bad, but a long stretch from pretty ;-)
>
> How would you 'encode' this in the perf callchain data?
>
>> These days we just look at dwarf augmentation string:
>>
>> http://git.savannah.gnu.org/gitweb/?p=libunwind.git;a=blob;f=src/dwarf/Gfde.c;h=8659624b0320c514057861a259b6efe1b605bbf3;hb=HEAD#l189
>
> Right, except of course we don't have that in kernel..
>

The ip-- transformation could happen in user space. The kernel doesn't 
have to know any of this :)

  -Arun

