Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2ITRg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:36:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58756 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752269Ab2ITRgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:36:55 -0400
Message-ID: <505B5379.5020106@fb.com>
Date: Thu, 20 Sep 2012 10:33:45 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCHSET 00/15] perf report: Add support to accumulate hist
 periods
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.254]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-09-20_05:2012-09-20,2012-09-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1207200000
 definitions=main-1209200200
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/12 12:19 AM, Namhyung Kim wrote:
> Hi,
>
> This is my first attempt to implement cumulative hist period report.
> This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
> rewrote it from scratch.

Tested-by: Arun Sharma <asharma@fb.com>

Our typical use case:

perf record -g fp ./foo
perf report --stdio --cumulate -g graph,100,callee

  -Arun
