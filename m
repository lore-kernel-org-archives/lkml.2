Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab0JUJI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:08:56 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54216 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0JUJIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GW9C1QTUX2a2qbr188+P7pXHdzsEfS9bmQpwiWh6xB5zLQT61sHWVdrjr8wcrKUHxm
         ZKQuhZtKxgzF5ajKFp3PqDAHGdV3mgrL7l8pyPiYhMGqZTQhuKeh07BD6DONtYHb270B
         mgto/dE6Mrw6W0cvZrlf9T5bjib4lQJDHv4bU=
MIME-Version: 1.0
In-Reply-To: <1287651542.2237.17.camel@myhost>
References: <1287647732.2237.7.camel@myhost>
	<AANLkTim7g+8_rQSyewC6n_5WmC04kU-rj1g9k61=O2Vm@mail.gmail.com>
	<1287649283.2237.8.camel@myhost>
	<AANLkTikzSZNtTGfOcP-87u+pMZyW8WrdxwV52ZV3f=nX@mail.gmail.com>
	<1287650668.2237.12.camel@myhost>
	<AANLkTi=D_a_BH-HW9mqwLim+DjxARWzT8mxP_dah5iLY@mail.gmail.com>
	<1287651542.2237.17.camel@myhost>
Date: Thu, 21 Oct 2010 17:08:51 +0800
Message-ID: <AANLkTinkMrsRQ8tdCrTj57SA_qHYrg+-qCqZpyQZ-FMr@mail.gmail.com>
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

On Thu, Oct 21, 2010 at 4:59 PM, Figo.zhang
<zhangtianfei@leadcoretech.com> wrote:
>
>> I just
>> echo  0 > tracing_enabled
>> echo function > current_tracer
>> echo 374(pid of flush) > set_ftrace_pid
>> echo 1 > tracing_enabled
>> wait some time
>> echo 0 > tracing_enabled
>> cat trace
>>
>> So I think this answer your question "could kthread be traced?"
>
> i do it the same of you.
>
> [root@myhost tracing]# ps -ax | grep flush
> Warning: bad ps syntax, perhaps a bogus '-'? See http://procps.sf.net/faq.html
>  1205 ?        S      0:01 [flush-8:0]
> 11852 pts/1    S+     0:00 grep flush
> [root@myhost tracing]#
>
> so my flusher pid is 1205, i do it as below:
>
> [root@myhost tracing]# echo 0 > tracing_enabled
> [root@myhost tracing]# echo function > current_tracer
> [root@myhost tracing]# echo 1205 > set_ftrace_pid
> [root@myhost tracing]# echo 1 > tracing_enabled
>
> wait ... and open some pdf files, let system eat huge memory...
>
> [root@myhost tracing]# echo 0 > tracing_enabled
> [root@myhost tracing]# cat trace
> # tracer: function
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>
>
> but i canot trace nothing.

Is tracing_on enable(1) on your system?
I enable it on my system by default, so I didn't show it in the previous mail.

Thanks,
Yong
