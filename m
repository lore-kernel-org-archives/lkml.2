Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab2CMSqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:46:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59118 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222Ab2CMSqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:46:05 -0400
Message-ID: <4F5F95BF.8060104@fb.com>
Date: Tue, 13 Mar 2012 11:45:19 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, <linux-perf-users@vger.kernel.org>
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
References: <1331160079-13821-1-git-send-email-asharma@fb.com> <4F5DA91F.7060908@lge.com> <4F5E3E8C.1020005@fb.com> <4F5E9FFA.7060300@lge.com>
In-Reply-To: <4F5E9FFA.7060300@lge.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-13_07:2012-03-13,2012-03-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/12 6:16 PM, Namhyung Kim wrote:

> $ perf record -g sleep 1
> $ perf report -s inclusive,symbol

Thanks. I was able to reproduce the hangs and they went away after I 
added sort_sym_inclusive (a copy of sort_sym, except for the se_header).

The output of perf report now better describes how the symbols are 
sorted. The text reads: "Symbol (Inclusive)".

v3 is coming via my next mail.

  -Arun

