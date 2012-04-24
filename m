Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab2DXAQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 20:16:47 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59991 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab2DXAQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 20:16:46 -0400
X-AuditID: 9c930197-b7ca1ae0000069e6-2f-4f95f0ecec7c
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/11] parse-filter: Check result of malloc() during reading token
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	<1335157118-14658-10-git-send-email-namhyung.kim@lge.com>
	<1335206917.28106.116.camel@gandalf.stny.rr.com>
Date: Tue, 24 Apr 2012 09:15:58 +0900
In-Reply-To: <1335206917.28106.116.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Mon, 23 Apr 2012 14:48:37 -0400")
Message-ID: <87lilmrnlt.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 23 Apr 2012 14:48:37 -0400, Steven Rostedt wrote:
> On Mon, 2012-04-23 at 13:58 +0900, Namhyung Kim wrote:
>> The malloc can fail so the return value should be checked.
>> For now, just use malloc_or_die().
>
> Applied, thanks!
>
> Although we will be getting rid of the 'die' feature. But at least this
> marks a location that we need to track.
>

Right. The point of this patch was that too. My next step will be the
removal of 'die' at all.

Thanks,
Namhyung
