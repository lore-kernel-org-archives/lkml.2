Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab1EFQys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:54:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53112 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab1EFQyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ZI0mwniDKfmitqwQN0SSoue/CKjkv7CONjgyCasRWvxEDxJehPim6OS0vxzEVf+B8g
         WJiImYAvzboGyTOS1vcq+Do9CmNyQinpqM9ycxMVCjUEieT1eoSu06h3pZN42I3P7+yu
         Cqq9nr7KIusOulKcQ7u+fi8DRdrDCoN/1v3FE=
Message-ID: <4DC427D4.7030903@gmail.com>
Date: Fri, 06 May 2011 18:54:44 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>
Subject: compiling of tools/perf fail on x86 64bit kernel and 32bit userspace
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with latest git, i cannot compile perf on 32 bit userspace with a 64 bit 
kernel.

~/src/linux-2.6/tools/perf$ make
PERF_VERSION = 2.6.39.rc6.224.g06d006f
     GEN common-cmds.h
     * new build flags or prefix
     CC perf.o
     CC builtin-annotate.o
     CC builtin-bench.o
     CC bench/sched-messaging.o
     CC bench/sched-pipe.o
     CC bench/mem-memcpy-x86-64-asm.o
bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
bench/../../../arch/x86/lib/memcpy_64.S:28: Error: bad register name `%rdi'
bench/../../../arch/x86/lib/memcpy_64.S:33: Error: invalid instruction 
suffix for `movs'

ARCH=x86 make works fine

thanks,
riccardo
