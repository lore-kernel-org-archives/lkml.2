Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531Ab2IEVSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:18:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56135 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440Ab2IEVSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:18:07 -0400
Message-ID: <5047C18B.9060602@gmail.com>
Date: Wed, 05 Sep 2012 15:18:03 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf: remove unneeded include of network header files
References: <1346255732-93246-1-git-send-email-dsahern@gmail.com> <20120905203903.GB8203@ghostprotocols.net>
In-Reply-To: <20120905203903.GB8203@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/12 2:39 PM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Aug 29, 2012 at 09:55:32AM -0600, David Ahern escreveu:
>> perf does not have networking related functionality, and the inclusion of
>> these headers is one of the causes of compile failures for Android:
>>    https://lkml.org/lkml/2012/8/23/316
>>    https://lkml.org/lkml/2012/8/28/293
>>
>> So, remove them.
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>
>      CC /home/acme/git/build/perf/util/scripting-engines/trace-event-python.o
> In file included from /usr/lib64/perl5/CORE/perl.h:1239,
>                   from util/scripting-engines/trace-event-perl.c:36:
> /usr/include/netdb.h:591: error: expected identifier or ‘(’ before ‘[’ token
> make: *** [/home/acme/git/build/perf/util/scripting-engines/trace-event-perl.o] Error 1
> make: *** Waiting for unfinished jobs....
> make: Leaving directory `/home/git/linux/tools/perf'

grr... removed the perl package testing the kconfig integration. forgot 
to reinstall. Will update.


