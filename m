Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab2CIIDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:03:33 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62735 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2CIIDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:03:32 -0500
X-AuditID: 9c930179-b7c4fae0000073fb-b8-4f59b94f1b5d
Message-ID: <4F59B94D.9010206@lge.com>
Date: Fri, 09 Mar 2012 17:03:25 +0900
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
References: <20120306062546.GA622@elte.hu> <1331085470-32594-1-git-send-email-namhyung.kim@lge.com> <20120307060724.GA4241@elte.hu> <4F5716A2.6070804@lge.com> <20120308104432.GB25949@elte.hu> <4F59629E.6090909@lge.com> <20120309073619.GB15570@elte.hu>
In-Reply-To: <20120309073619.GB15570@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-03-09 4:36 PM, Ingo Molnar wrote:
> Well, the main problem I had was that they showed up in the
> 'perf report sched' filtered output and messed it up.
>
> I.e. I'm not interested in unknown symbols much, I'm interested
> in *not* seeing them when I type 'perf report sched'.
>

It should be easy to get rid of unknown symbols from filtered output. So I 
just wanted how to deal with if someone would need to show (part of) those 
symbols only. But now I guess it could be handled at dso/comm level.

Thanks,
Namhyung

