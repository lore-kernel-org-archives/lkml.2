Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761039Ab2C3RJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:09:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38309 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab2C3RJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:09:17 -0400
Message-ID: <4F75E8BA.4090907@gmail.com>
Date: Fri, 30 Mar 2012 10:09:14 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 9/9] perf tools: Remove auto-generated bison/flex files
References: <1333123764-15662-1-git-send-email-acme@infradead.org>	<1333123764-15662-10-git-send-email-acme@infradead.org> <87iphmm44e.fsf@gmail.com>
In-Reply-To: <87iphmm44e.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 09:43 AM, Namhyung Kim wrote:
> Hi,
>
> Arnaldo Carvalho de Melo<acme@infradead.org>  wrote:
>> From: Ingo Molnar<mingo@kernel.org>
>>
>> These should not be in the Git history - they are auto-generated.
>>
>> Extend the Makefile rules of the parser files to include the generation
>> run.
>>
>> Signed-off-by: Ingo Molnar<mingo@elte.hu>
[...]
>>
>> +FLEX = $(CROSS_COMPILE)flex
>> +BISON= $(CROSS_COMPILE)bison
>
> Just out of curiousity, is this $(CROSS_COMPILE) prefix really needed
> for flex/bison?
>

I think not.  Actually, I think it is actively incorrect.

I have done quite a bit of cross building of things requiring either 
bison or flex, and have never encountered  $(CROSS_COMPILE)bison, so I 
would think that it is unlikely that many people have one.  On the other 
hand the native tools work fine.

David Daney



