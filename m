Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab0JUNdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:33:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab0JUNdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:33:50 -0400
Subject: Re: Ftrace: can trace kthread?
From: Steven Rostedt <srostedt@redhat.com>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1287647732.2237.7.camel@myhost>
References: <1287647732.2237.7.camel@myhost>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Thu, 21 Oct 2010 09:33:43 -0400
Message-ID: <1287668023.2824.15.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a quick note. Please send email to my rostedt@goodmis.org address.
I do not check my srostedt@redhat.com address as often.

I know, I know, I have it as my Author tag (but not my signed off by)
and I had to add it to my business card. I just could not be so bold as
to put my goodmis.org address on my Red Hat business card ;-) And there
was no good way to add it as a secondary.

-- Steve

On Thu, 2010-10-21 at 15:55 +0800, Figo.zhang wrote:
> hi,
> 
> is it ftrace in 2.6.36-rc8 can trace the kthread? i want to trace the
> kswapd/bdi_writeback_thread, but not success. i am sure that kswapd is
> running, because i let the system eat huge memory. i can trace some
> function such as __do_fault. what is issue on it? 
> 
> Best,
> Figo.zhang
> 
> 
> here is my ftrace script.
> i = 1
> while true;
> do
> 	echo 1 > /proc/sys/kernel/ftrace_enabled
> 	echo function_graph > /sys/kernel/debug/tracing/current_tracer
> 	echo kswapd > /sys/kernel/debug/tracing/set_graph_function
> 	echo 1 > /sys/kernel/debug/tracing/tracing_on
> 	echo 1 > /sys/kernel/debug/tracing/tracing_enabled
> 	sleep 1
> 	echo 0 > /sys/kernel/debug/tracing/tracing_enabled
> 	cat /sys/kernel/debug/tracing/trace > ftrace.kswap.log.$i
> 
> 	let i=i+1;
> 
> done
> 
> 
> 


