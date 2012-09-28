Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2I1GKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:10:24 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58677 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab2I1GKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:10:22 -0400
X-AuditID: 9c93016f-b7b1eae000000815-e8-50653f4c677f
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 06/14] perf tool: Add hpp interface to enable/disable hpp column
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
	<1348744175-11115-7-git-send-email-jolsa@redhat.com>
Date: Fri, 28 Sep 2012 15:02:11 +0900
In-Reply-To: <1348744175-11115-7-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Thu, 27 Sep 2012 13:09:27 +0200")
Message-ID: <87vceyu1lo.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012 13:09:27 +0200, Jiri Olsa wrote:
> Adding perf_hpp__column_enable function to enable/disable hists
> column and removing diff command specific stuff 'need_pair and
> show_displacement' from hpp code.
>
> The diff command now enables/disables columns separately according
> to the user arguments. This will be helpful in future patches where
> more columns are added into diff output.

This is what I wanted to do. :)

Thanks,
Namhyung
