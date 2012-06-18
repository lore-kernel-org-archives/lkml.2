Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2FRIja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:39:30 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45796 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2FRIj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:39:29 -0400
X-AuditID: 9c930197-b7b87ae000000e4d-fd-4fdee93bbf41
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>, rostedt@goodmis.org,
        acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, weisbec@gmail.com, namhyung.kim@lge.com,
        mingo@kernel.org, peterz@infradead.org
Subject: Re: [RFC PATCH 0/2] libtraceevent/perf: Add support for trace-cmd plugins
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
Date: Mon, 18 Jun 2012 17:35:56 +0900
In-Reply-To: <1339695333-64591-1-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Thu, 14 Jun 2012 11:35:31 -0600")
Message-ID: <87lijlhv9v.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

On Thu, 14 Jun 2012 11:35:31 -0600, David Ahern wrote:
> Now that perf is using libtraceevent and libtraceevent is based
> on trace-cmd both can be extended to leverage the plugins written
> for trace-cmd to improve pretty printing of the events.
>
> Given that it is based on code from trace-cmd I am not sure what the
> right approach is, so wanted to throw this out for comments/suggestions.
>

Yeah, it can be useful to reuse existing code for extending the
functionality. But I'm not so sure including the plugin APIs into
libtraceevent is the right thing (at least in its current form).

And for this particular case in patch 2/2, it seems that format of the
kvm_emulate_insn event is broken already and should be fixed anyway.
Further improvement in this area can be addressed in perf kvm or other
users if needed.

So I'd like to hear from others.
Arnaldo and Steven, what do you think?

Thanks,
Namhyung
