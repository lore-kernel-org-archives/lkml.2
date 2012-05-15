Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab2EOJdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 05:33:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59107 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab2EOJdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 05:33:47 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-08-4fb222f9c2f3
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ulrich Drepper <drepper@gmail.com>
Subject: Re: [PATCH 12/11] parse-events: Cleanup realloc use
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	<1335230984-7613-1-git-send-email-namhyung.kim@lge.com>
	<87r4ulzvmj.fsf@sejong.aot.lge.com>
	<1337071725.14207.287.camel@gandalf.stny.rr.com>
Date: Tue, 15 May 2012 18:32:09 +0900
In-Reply-To: <1337071725.14207.287.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Tue, 15 May 2012 04:48:45 -0400")
Message-ID: <87ipfxzt5y.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 15 May 2012 04:48:45 -0400, Steven Rostedt wrote:
> On Tue, 2012-05-15 at 17:39 +0900, Namhyung Kim wrote:
>> Ping?
>
> The 12/11 fooled me ;-)  I added 1-11 but as my email is not sorted
> well, I stopped at 11/11 (thinking that was the last patch).
>

Sorry, it should be sent separately. I'll not do it again.


> I'll take a look at this one.
>

Thanks,
Namhyung
