Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab2FZAjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:39:05 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45941 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab2FZAjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:39:03 -0400
X-AuditID: 9c930197-b7c94ae0000037ff-15-4fe904a4d4db
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, psuriset@linux.vnet.ibm.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf kvm: fix segfault with default guest arguments
References: <1340599286-89757-1-git-send-email-dsahern@gmail.com>
	<877guvwzt1.fsf@sejong.aot.lge.com> <4FE85EB6.80908@gmail.com>
	<4FE8B656.4080201@gmail.com>
Date: Tue, 26 Jun 2012 09:35:14 +0900
In-Reply-To: <4FE8B656.4080201@gmail.com> (David Ahern's message of "Mon, 25
	Jun 2012 13:04:54 -0600")
Message-ID: <87395ix64d.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012 13:04:54 -0600, David Ahern wrote:
> On 6/25/12 6:51 AM, David Ahern wrote:
>> On 6/25/12 2:39 AM, Namhyung Kim wrote
>>>
>>> I don't know about the kvm, but isn't there a possibility that the same
>>> thing happends on other types of event too - i.e. comm, fork, exit..?
>>
>> COMM, FORK, EXIT events cannot be generated in the guest of a guest;
>> host machine is always non-NULL.
>
> s/guest of a guest/context of a guest/
>
> [That's I what get for rushing an email as I run out the door this morning.]

:) Thanks for the correction!

Thanks,
Namhyung
