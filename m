Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab2DXAKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 20:10:25 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42662 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab2DXAKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 20:10:24 -0400
X-AuditID: 9c930197-b7ca1ae0000069e6-66-4f95ef6dd21e
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/11] parse-events: Get rid of handling concatenation on event_read_print
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	<1335157118-14658-4-git-send-email-namhyung.kim@lge.com>
	<1335198822.28106.105.camel@gandalf.stny.rr.com>
Date: Tue, 24 Apr 2012 09:09:35 +0900
In-Reply-To: <1335198822.28106.105.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Mon, 23 Apr 2012 12:33:42 -0400")
Message-ID: <87pqayrnwg.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 23 Apr 2012 12:33:42 -0400, Steven Rostedt wrote:
> On Mon, 2012-04-23 at 13:58 +0900, Namhyung Kim wrote:
>> The concatenation of subsequent DQUOTE'd strings is handled
>> by __read_token() already.
>> 
>
> You missed the point of this concat. It's not connecting "xxx" it is
> connecting "xxx" "yyy" into "xxxyyy", as some events do this.
>

I think I don't :). Please see commit 0f15820 ("parse-events:
Concatinate two strings that are adjacent").

Thanks,
Namhyung
