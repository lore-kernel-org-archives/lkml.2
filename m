Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2CaFnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 01:43:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33585 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751997Ab2CaFnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 01:43:47 -0400
Message-ID: <4F769976.3070203@fb.com>
Date: Fri, 30 Mar 2012 22:43:18 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Arun Sharma <asharma@fb.com>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        <linux-perf-users@vger.kernel.org>
Subject: Re: [PATCH] perf: Add a new sort order: SORT_INCLUSIVE (v6)
References: <1333172421-6775-2-git-send-email-asharma@fb.com>
In-Reply-To: <1333172421-6775-2-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-31_01:2012-03-30,2012-03-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Meant to include v6 ChangeLog as well. Technical difficulties.. ]

v6 ChangeLog:

rebased to tip:perf/core and fixed a minor problem in computing
the total period in hists__remove_entry_filter(). Needed to
use period_self instead of period.
