Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab2FSCR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:17:29 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43945 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2FSCR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:17:26 -0400
X-AuditID: 9c93016f-b7b77ae000002344-5c-4fdfe1320d91
From: Namhyung Kim <namhyung@kernel.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jim Cromie <jim.cromie@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, <stable@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Fix default logfd to use stderr
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
	<1317336490-19437-8-git-send-email-acme@infradead.org>
	<20120618145108.GG5046@erda.amd.com>
Date: Tue, 19 Jun 2012 11:13:59 +0900
In-Reply-To: <20120618145108.GG5046@erda.amd.com> (Robert Richter's message of
	"Mon, 18 Jun 2012 16:51:08 +0200")
Message-ID: <87zk80giag.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Robert

On Mon, 18 Jun 2012 16:51:08 +0200, Robert Richter wrote:
> On 29.09.11 18:48:01, Arnaldo Carvalho de Melo wrote:
>> From: Jim Cromie <jim.cromie@gmail.com>
>> 
>> This perf stat option emulates valgrind's --log-fd option, allowing the
>> user to send perf results elsewhere, and leaving stderr for use by the
>> program under test.  This complements --output file option, and is
>> mutually exclusive with it.
>> 
>>    3>results  perf stat --log-fd 3          -- $cmd
>>    3>>results perf stat --log-fd 3 --append -- $cmd
>> 
>> The perl distro's make test.valgrind target uses valgrind's --log-fd
>> option, I've adapted it to invoke perf also, and tested this patch
>> there.
>> 
>> Link: http://lkml.kernel.org/r/1315437244-3788-2-git-send-email-jim.cromie@gmail.com
>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> With certain shell redirections this (56f3bae) fails with a log fd
> setup failure. Fix below.
>

It looks somewhat related to Stephane's patch. Can you we check it too?

http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/04232.html

Thanks,
Namhyung
