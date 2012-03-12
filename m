Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2CLTff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:35:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40237 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755851Ab2CLTfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:35:34 -0400
Message-ID: <4F5E4FF6.2010901@fb.com>
Date: Mon, 12 Mar 2012 12:35:18 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        <linux-perf-users@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf: Add a new sort order: SORT_INCLUSIVE
References: <1331160079-13821-1-git-send-email-asharma@fb.com> <1331160079-13821-3-git-send-email-asharma@fb.com> <20120308072258.GB20784@elte.hu>
In-Reply-To: <20120308072258.GB20784@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-12_05:2012-03-12,2012-03-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/12 11:22 PM, Ingo Molnar wrote:

>
> I.e. this refactoring and splitup of the function into two parts
> is not a detail that should matter to builtin-report.c's
> perf_evsel__add_hist_entry().
>

Agreed. I'll fold this into the next rev.

  -Arun
