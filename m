Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab2HVHbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:31:37 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51972 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab2HVHbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:31:31 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-44-50348ad165a8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] tools lib traceevent: Basic error handling
References: <1345618831-9148-1-git-send-email-namhyung@kernel.org>
Date: Wed, 22 Aug 2012 16:24:43 +0900
In-Reply-To: <1345618831-9148-1-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Wed, 22 Aug 2012 16:00:27 +0900")
Message-ID: <877gsrie2s.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Wed, 22 Aug 2012 16:00:27 +0900, Namhyung Kim wrote:
> I almost forgot that I have some libtraceevent patch left. ;)  The
> first three of them are acked by Steven and the last is a port of a
> recent perf patch from Kirill that handles a strerror_r build warning.
> Please consider applying.

I also forgot that I didn't remove the Link: line from the changelogs
before sending them, sorry.  Anyway, you can pull this series from my
tree which contains libtraceevent/core branch, if you like (I added a
Link to patch 4 there for your convenience).

Thanks,
Namhyung
