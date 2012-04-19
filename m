Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2DSDvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 23:51:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45387 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab2DSDvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 23:51:03 -0400
Message-ID: <4F8F8B9E.3040107@gmail.com>
Date: Thu, 19 Apr 2012 11:50:54 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Tu, Xiaobing" <xiaobing.tu@intel.com>
CC: Lin Ming <mlin@ss.pku.edu.cn>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool
References: <EE928378561BF1449699C96571234A740FCED62F@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <EE928378561BF1449699C96571234A740FCED62F@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 10:37 PM, Tu, Xiaobing wrote:
> Resend the patch because of the log is too long on a single line.
>
> From: xiaobing tu<xiaobing.tu@intel.com>
>
> Here is the kernel patch for this tool, The idea is to output user space stack call-chain from
> /proc/xxx/stack, currently, /proc/xxx/stack only output kernel stack call chain. We extend
> it to output user space call chain in hex format
>

Can you teach me why we still need this as we have pstack?

~% pstack $$
#0  0x00000036ae2365da in sigsuspend () from /lib64/libc.so.6
#1  0x0000000000472c25 in signal_suspend ()
#2  0x0000000000443323 in ?? ()
#3  0x0000000000443be6 in waitjobs ()
#4  0x000000000042b6d3 in ?? ()
#5  0x000000000042c0bd in execlist ()
#6  0x000000000042c64f in execode ()
#7  0x000000000043cd32 in loop ()
#8  0x000000000043fb36 in zsh_main ()
#9  0x00000036ae22169d in __libc_start_main () from /lib64/libc.so.6
#10 0x000000000040e571 in _start ()

Thanks!
