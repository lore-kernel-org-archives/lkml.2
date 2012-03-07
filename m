Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab2CGIFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 03:05:01 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48347 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2CGIFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 03:05:00 -0500
X-AuditID: 9c930197-b7bf3ae000001009-a9-4f5716a8c541
Message-ID: <4F5716A2.6070804@lge.com>
Date: Wed, 07 Mar 2012 17:04:50 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Ingo Molnar <mingo@elte.hu>
CC: Namhyung Kim <namhyung@gmail.com>, Arun Sharma <asharma@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        robert.richter@amd.com, ming.m.lin@intel.com, vweaver1@eecs.utk.edu,
        andi@firstfloor.org
Subject: Re: [RFC] perf report: Implement symbol filtering on TUI
References: <20120306062546.GA622@elte.hu> <1331085470-32594-1-git-send-email-namhyung.kim@lge.com> <20120307060724.GA4241@elte.hu>
In-Reply-To: <20120307060724.GA4241@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo

2012-03-07 3:07 PM, Ingo Molnar wrote:
>
> * Namhyung Kim <namhyung.kim@lge.com>  wrote:
>
>> As Ingo requested, symbol filtering feature was missing on TUI.
>> Add 's' key to get input from user, and do simple filtering by
>> strstr(). To turn filtering off, just enter no name by pressing
>> 's' followed by ENTER.
>>
>> There should be many issues, but I just want to release this
>> to get some feedbacks.
>
> I'd love it if in addition to the hotkey, if I typed the obvious
> sequence:
>
>   $ perf report sched
>
> ... then it would turn into such a filter automagically.
>

Oh, I implemented that already. Please test it! :)

Thanks,
Namhyung
