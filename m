Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0JUIKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:10:39 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53459 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab0JUIKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:10:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bxDAiApleHMUQZJsTu+EFfSVB2y726t48YfnLCrbKhBLSSRqIPfymD5Mg9cB3/J2Fa
         Nq+oGCa5BFu5wF9mz1iHZLa9wwAzDRCZhTQUnqTpY8RAEGlydsPejcgJaGy9j6cZznHb
         uBho6dGG+YQXAehcBvTkzvWWRw8DXQ4/xw760=
MIME-Version: 1.0
In-Reply-To: <1287647732.2237.7.camel@myhost>
References: <1287647732.2237.7.camel@myhost>
Date: Thu, 21 Oct 2010 16:10:36 +0800
Message-ID: <AANLkTim7g+8_rQSyewC6n_5WmC04kU-rj1g9k61=O2Vm@mail.gmail.com>
Subject: Re: Ftrace: can trace kthread?
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 3:55 PM, Figo.zhang
<zhangtianfei@leadcoretech.com> wrote:
> hi,
>
> is it ftrace in 2.6.36-rc8 can trace the kthread?

How about the set_ftrace_pid interface?

Thanks,
Yong

> i want to trace the
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
>        echo 1 > /proc/sys/kernel/ftrace_enabled
>        echo function_graph > /sys/kernel/debug/tracing/current_tracer
>        echo kswapd > /sys/kernel/debug/tracing/set_graph_function
>        echo 1 > /sys/kernel/debug/tracing/tracing_on
>        echo 1 > /sys/kernel/debug/tracing/tracing_enabled
>        sleep 1
>        echo 0 > /sys/kernel/debug/tracing/tracing_enabled
>        cat /sys/kernel/debug/tracing/trace > ftrace.kswap.log.$i
>
>        let i=i+1;
>
> done
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
