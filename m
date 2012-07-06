Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab2GFRTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:19:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62269 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab2GFRTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:19:14 -0400
Message-ID: <4FF71E0E.8010602@gmail.com>
Date: Fri, 06 Jul 2012 11:19:10 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf tool: save cmdline from user in file header vs what
 is passed to record
References: <1341547762-17430-1-git-send-email-dsahern@gmail.com> <20120706171735.GH7533@infradead.org>
In-Reply-To: <20120706171735.GH7533@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/6/12 11:17 AM, Arnaldo Carvalho de Melo wrote:
> Can you please state for what branch, perf/urgent (i.e. current merge
> window) or perf/core (next), this is intended? I usually have been
> making the call, but having feedback from the submitter can help things
> and help meet expectations more frequently.
>
> I'd say this one should be for perf/core, as it is not so critical, what
> do you think?

right, need to add that tag. It's not a regression, just an oversight on 
the original implementation. perf/core is the right branch.

David


