Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1EGOqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 10:46:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44548 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab1EGOqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 10:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jIjCMmfs5oG05Fjh6Y+PNfX3ZDZO8a6eJSHkdvrVtw/E2XG87fpCj5yBYIZpy7xgr7
         s8nqAEuDRNPuCBeThEheoNlOAOLppTp2pum2LFYckQh8cj+/v96yMaVk8NRrtOfLDeDV
         O54W95YE7MnHZRSlnefMeXX/KIp8XNFkarb2o=
Message-ID: <4DC55B50.1030108@gmail.com>
Date: Sat, 07 May 2011 16:46:40 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: Lin Ming <minggr@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: compiling of tools/perf fail on x86 64bit kernel and 32bit userspace
References: <4DC427D4.7030903@gmail.com> <BANLkTikvtJex=fGYw0f6v8pMKhkWmaM2sA@mail.gmail.com>
In-Reply-To: <BANLkTikvtJex=fGYw0f6v8pMKhkWmaM2sA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Il 07/05/2011 06:55, Lin Ming ha scritto:
> On Sat, May 7, 2011 at 12:54 AM, Riccardo Magliocchetti
> <riccardo.magliocchetti@gmail.com>  wrote:
>> Hi,
>>
>> with latest git, i cannot compile perf on 32 bit userspace with a 64 bit
>> kernel.
>>
>> ~/src/linux-2.6/tools/perf$ make
>> PERF_VERSION = 2.6.39.rc6.224.g06d006f
>>     GEN common-cmds.h
>>     * new build flags or prefix
>>     CC perf.o
>>     CC builtin-annotate.o
>>     CC builtin-bench.o
>>     CC bench/sched-messaging.o
>>     CC bench/sched-pipe.o
>>     CC bench/mem-memcpy-x86-64-asm.o
>> bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
>> bench/../../../arch/x86/lib/memcpy_64.S:28: Error: bad register name `%rdi'
>> bench/../../../arch/x86/lib/memcpy_64.S:33: Error: invalid instruction
>> suffix for `movs'
>
> Hi,
>
> I just send out a patch to fix this.
> https://lkml.org/lkml/2011/5/7/4
>
> Could you have a try it?

Works fine, thanks!

riccardo
