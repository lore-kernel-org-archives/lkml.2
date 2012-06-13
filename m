Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab2FMDAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 23:00:46 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65068 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2FMDAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 23:00:45 -0400
X-AuditID: 9c93016f-b7c3cae000001954-50-4fd8025bb028
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCHSET 0/3] tools lib traceevent: Generic error handling for pevent
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
	<1339523386.13377.135.camel@gandalf.stny.rr.com>
Date: Wed, 13 Jun 2012 11:57:49 +0900
In-Reply-To: <1339523386.13377.135.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Tue, 12 Jun 2012 13:49:46 -0400")
Message-ID: <87ipev6hqq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 12 Jun 2012 13:49:46 -0400, Steven Rostedt wrote:
> On Tue, 2012-06-12 at 16:42 +0900, Namhyung Kim wrote:
>
>> I don't like the name 'pevent' but since it's a part of the API
>> so I used it for the name.
>> 
>
> Have a better suggestion? It's still a rather new API. We can still
> change trace-cmd and power-top if we can come up with a better naming
> convention.
>
> Speak now or forever hold your piece ;-) (or is that peace?)
>

I don't think I have a good naming sense. :/

As the library name changed, 'tevent' might look like little bit better,
but I'm not sure it's worth changing. How about 'libte', 'lte', or
'lkte' for linux (kernel) trace event? For the last case, 'telk' (trace
event for linux kernel) might be a better name to pronounce.

Any better suggestions?

Thanks,
Namhyung
