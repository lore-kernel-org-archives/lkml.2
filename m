Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1JOTJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 15:09:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40961 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab1JOTJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 15:09:37 -0400
Message-ID: <4E99DA6C.3030906@gmail.com>
Date: Sat, 15 Oct 2011 13:09:32 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [GIT PULL 0/5] perf/core improvements and fixes
References: <1318616873-26739-1-git-send-email-acme@infradead.org> <20111015145946.GB9516@elte.hu> <4E99BC44.40400@gmail.com> <20111015170452.GD29782@elte.hu> <4E99C6E6.2040201@gmail.com> <20111015190620.GA21352@ghostprotocols.net>
In-Reply-To: <20111015190620.GA21352@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/15/2011 01:06 PM, Arnaldo Carvalho de Melo wrote:
>>
>> It should. The message comes from map__load() when it detects a deleted
>> mapping such as:
>>
>> 7f9e8d5c7000-7f9e8d5c8000 rw-p 0000c000 fd:02 1046947
>>  /lib64/libpam.so.0.82.2.#prelink#.cM3f72 (deleted)
>>
>> I have removed prelink from most of my systems (managed to find one lone
>> server with the above).
> 
> David,
> 
> 	Can you send me a patch that clarifies this situation?
> 
> - Arnaldo

Clarifies in what way? The code checks for "(deleted)" on the dso and
suggests a restart of the process.

David
