Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab2GCBC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:02:57 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54269 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab2GCBC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:02:56 -0400
X-AuditID: 9c93016f-b7bccae00000345c-67-4ff244bda4b0
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: Re: [PATCH 2/3] perf, tool: Enable grouping logic for parsed events
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
	<1340960907-3725-3-git-send-email-jolsa@redhat.com>
	<87bojync4b.fsf@sejong.aot.lge.com>
	<20120702101010.GB967@krava.redhat.com>
Date: Tue, 03 Jul 2012 09:58:44 +0900
In-Reply-To: <20120702101010.GB967@krava.redhat.com> (Jiri Olsa's message of
	"Mon, 2 Jul 2012 12:10:10 +0200")
Message-ID: <873959mzi3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012 12:10:10 +0200, Jiri Olsa wrote:
> On Mon, Jul 02, 2012 at 11:13:56AM +0900, Namhyung Kim wrote:
>> On Fri, 29 Jun 2012 11:08:26 +0200, Jiri Olsa wrote:
>> > It's possible to use standard event modifier for a group, which spans
>> > over all events in the group and overrides any event modifier settings,
>> > for example:
>> >
>> >   # perf record -r '{faults:k,cache-references}:u'
>> >
>> > resulting in ':u' modifier being used for both 'faults' and 'cache-references'
>> > events, regardless of their modifier setup (':k' for faults event).
>> >
>> 
>> So the faults event would get only 'u' for the modifier not 'uk', right?
>
> right
>

I was thinking about the combining the modifiers - i.e. make it 'uk'
above. Not sure it's useful in general, but something like "adding 'p'
to the leader (only)" looks good to have IMHO.

Thanks,
Namhyung
