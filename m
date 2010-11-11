Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab0KKHwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 02:52:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51058 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356Ab0KKHwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 02:52:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wpsxjdZbPBB6ORFSQFSUYnm3cEAr7lqiT6o9fTsJuTOqLqmc6kwf2d6rXG23Z+ELvR
         7Pc2nadfTZuxWrgORtuO0ovG8RB3HfXGFJoOqY3hOFN07Qr4aY1zlbxcUJt2gvyEBCtA
         7l0AhPqAIOJd+HoIZHRBQURYo4eEZqhgA+0M0=
MIME-Version: 1.0
In-Reply-To: <AANLkTinwAL8dFsDbd-ZTQEcEziq6jZk82KPzNqMVxnOx@mail.gmail.com>
References: <AANLkTinwAL8dFsDbd-ZTQEcEziq6jZk82KPzNqMVxnOx@mail.gmail.com>
Date: Thu, 11 Nov 2010 15:52:07 +0800
Message-ID: <AANLkTim+BAYKWqiJzSQQLc4e_yNkMsNNnEp5u8YgC2Fk@mail.gmail.com>
Subject: Re: [Questions] How to run 'perf top' on ARM to profile kernel
 functions with modules loaded
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/11 Ming Lei <tom.leiming@gmail.com>:
> Hi,
>
> 'perf top' can't display any functions when modules are loaded on ARM.

Sorry, should be can't display any kernel functions when modules are loaded
on ARM.

Also, when modules are loaded, 'perf report' can't display functions names,
follows result of 'perf report':

root@beagleboard:~# perf report
# Events: 4K cycles
#
# Overhead      Command      Shared Object                  Symbol
# ........  ...........  .................  ......................
#
    97.36%      swapper  [musb_hdrc]        [k]  10466c4
     2.19%         perf  [musb_hdrc]        [k]  10da070
     0.09%  ksoftirqd/0  [musb_hdrc]        [k]  10db998
     0.06%         perf  libc-2.9.so        [.] memchr
     0.04%         perf  libc-2.9.so        [.]    663c0
     0.02%         perf  perf               [.]     2e80
     0.02%         perf  libc-2.9.so        [.] closedir
     0.02%         perf  libc-2.9.so        [.] __read
     0.02%  flush-179:0  [musb_hdrc]        [k]  10ff124
     0.02%         perf  libc-2.9.so        [.] memset
     0.02%         perf  libc-2.9.so        [.] __memcpy_chk
     0.02%         perf  perf               [.] event__synthesize_comm
     0.02%         perf           ffff0fc4  [.] ffff0fc4
     0.02%         perf  perf               [.] hex2u64
     0.02%         perf  libc-2.9.so        [.] _IO_vfprintf
     0.02%         perf  libc-2.9.so        [.] fgets
     0.02%         perf  libpthread-2.9.so  [.] flockfile
     0.02%         perf  perf               [.] kallsyms__parse
     0.02%         perf  libc-2.9.so        [.] _IO_getline_info

Any suggestions or comments?

thanks,
-- 
Lei Ming
