Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1BATcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:32:50 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:41148 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab1BATct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:32:49 -0500
Message-ID: <4D485F7E.8020800@kernel.org>
Date: Tue, 01 Feb 2011 11:31:10 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf top: Introduce slang based TUI
References: <new-submission> <tip-c0443df1b69b59675fc6790e0ddce87c8ca00abf@git.kernel.org> <4D48562B.20006@kernel.org> <20110201192808.GD25544@ghostprotocols.net>
In-Reply-To: <20110201192808.GD25544@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 11:28 AM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Feb 01, 2011 at 10:51:23AM -0800, Yinghai Lu escreveu:
>> On 02/01/2011 01:20 AM, tip-bot for Arnaldo Carvalho de Melo wrote:
>>> +	slsmg_write_nstring(width >= syme->map->dso->long_name_len ?
>>> +				syme->map->dso->long_name :
>>> +				syme->map->dso->short_name, width);
>>
>>
>> need update macro for that calling
>>
>> [PATCH] perf: fix compiling for perf top tui
>>
>> util/ui/browsers/top.c: In function ‘perf_top_browser__write’:
>> util/ui/browsers/top.c:60:2: error: cast to pointer from integer of different size
>> util/ui/browsers/top.c:60:2: error: comparison between pointer and integer
>> util/ui/browsers/top.c:60:2: error: passing argument 1 of ‘SLsmg_write_nstring’ discards qualifiers from pointer target type
>> /usr/include/slang.h:1728:16: note: expected ‘char *’ but argument is of type ‘const char *’
>> make: *** [util/ui/browsers/top.o] Error 1
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Good catch, why I didn't got this here is a mistery... anyway, applying,
> thanks,

my laptop have opensuse 11.3...

assume would not have that setup.

Yinghai
