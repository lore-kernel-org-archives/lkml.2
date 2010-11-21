Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab0KUQGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 11:06:13 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48506 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0KUQGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 11:06:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=TnW8f9MLfSML7mk5Wq4JKBRRHoMHvJzkGuahVLdB3o6mbrv3kwrJEZJOL5eJAj+0VM
         Tjk0D4PpK1sjyG7pBmkaGcXeqwo9EPef5gAX82iTAasqqVqsbRCSf6fhW+bxZEZbEMZ3
         9Mf9AkT/c0Cynsa75HYqTvWPmjv/M1YFuh2BM=
MIME-Version: 1.0
Date: Mon, 22 Nov 2010 00:06:10 +0800
Message-ID: <AANLkTi==JZK7r27zQndo7V5fjKMfyoVdzxESMJCXLBwR@mail.gmail.com>
Subject: [BUG] perf-tip: compile failure on ARM
From: Ming Lei <tom.leiming@gmail.com>
To: mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Building -tip tree on ARM failed, follows the error messge:


  CC      kernel/trace/trace_syscalls.o
In file included from kernel/trace/trace_syscalls.c:2:
include/trace/events/syscalls.h:11:25: error: asm/syscall.h: No such
file or directory
kernel/trace/trace_syscalls.c:15: error: 'NR_syscalls' undeclared here
(not in a function)
kernel/trace/trace_syscalls.c: In function 'ftrace_syscall_enter':
kernel/trace/trace_syscalls.c:306: error: implicit declaration of
function 'syscall_get_nr'
kernel/trace/trace_syscalls.c:325: error: implicit declaration of
function 'syscall_get_arguments'
kernel/trace/trace_syscalls.c: In function 'ftrace_syscall_exit':
kernel/trace/trace_syscalls.c:357: error: implicit declaration of
function 'syscall_get_return_value'
kernel/trace/trace_syscalls.c: In function 'reg_event_syscall_enter':
kernel/trace/trace_syscalls.c:374: error: implicit declaration of
function 'register_trace_sys_enter'
kernel/trace/trace_syscalls.c: In function 'unreg_event_syscall_enter':
kernel/trace/trace_syscalls.c:394: error: implicit declaration of
function 'unregister_trace_sys_enter'
kernel/trace/trace_syscalls.c: In function 'reg_event_syscall_exit':
kernel/trace/trace_syscalls.c:408: error: implicit declaration of
function 'register_trace_sys_exit'
kernel/trace/trace_syscalls.c: In function 'unreg_event_syscall_exit':
kernel/trace/trace_syscalls.c:428: error: implicit declaration of
function 'unregister_trace_sys_exit'
kernel/trace/trace_syscalls.c: In function 'arch_syscall_addr':
kernel/trace/trace_syscalls.c:451: error: 'sys_call_table' undeclared
(first use in this function)
kernel/trace/trace_syscalls.c:451: error: (Each undeclared identifier
is reported only once
kernel/trace/trace_syscalls.c:451: error: for each function it appears in.)
make[2]: *** [kernel/trace/trace_syscalls.o] Error 1
make[1]: *** [kernel/trace] Error 2
make: *** [kernel] Error 2
make: *** Waiting for unfinished jobs....

thanks,
-- 
Lei Ming
