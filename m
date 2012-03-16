Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161287Ab2CPI1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:27:08 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43314 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965186Ab2CPI1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:27:02 -0400
X-AuditID: 9c930197-b7c59ae000000e75-da-4f62f95375d8
Message-ID: <4F62F94F.4040103@lge.com>
Date: Fri, 16 Mar 2012 17:26:55 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf report: Fix calculation of the symbol column width
References: <1331615369-23324-1-git-send-email-namhyung.kim@lge.com> <20120315173421.GG9528@infradead.org>
In-Reply-To: <20120315173421.GG9528@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-03-16 2:34 AM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Mar 13, 2012 at 02:09:29PM +0900, Namhyung Kim escreveu:
>> The calculation of each column width is determining longest string or
>> number in the data (including header). However printing symbol column
>> doesn't honor the width. This is fine if symbol column is printed at
>> last (default behavior), but if user changes the order using -s option
>> the output will be messed up:
>
> This one is clashing with b5387528:
>
> "perf tools: Add code to support PERF_SAMPLE_BRANCH_STACK"
>
> Ingo merged it recently, can you please respin this patch on perf/core?
>

Hmm.. It was already fixed by the commit above. Please feel free to ignore this.

Thanks,
Namhyung
