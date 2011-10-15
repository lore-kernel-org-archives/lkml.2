Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1JORA7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 13:00:59 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48171 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab1JORA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 13:00:58 -0400
Message-ID: <4E99BC44.40400@gmail.com>
Date: Sat, 15 Oct 2011 11:00:52 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/5] perf/core improvements and fixes
References: <1318616873-26739-1-git-send-email-acme@infradead.org> <20111015145946.GB9516@elte.hu>
In-Reply-To: <20111015145946.GB9516@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2011 08:59 AM, Ingo Molnar wrote:
> Btw., i noticed another weirdness - sometimes after startup i get 
> this message:
> 
> /lib64/libc-2.14.90.so was updated, restart the long running apps that use it!                          
> 
> but it was not updated recently:
> 
>  earth5:~/tip/tools/perf> ll /lib64/libc-2.14.90.so
>  -rwxr-xr-x 1 root root 2062920 Sep 28 15:11 /lib64/libc-2.14.90.so
>  earth5:~/tip/tools/perf> date
>  Sat Oct 15 16:59:04 CEST 2011
>  earth5:~/tip/tools/perf> uptime
>   16:59:08 up 19 days, 21:35, 11 users,  load average: 7.77, 7.48, 3.81

I got the impression that comment was relative to when the processes
were started versus prelink touching it. In your case the mod time of
libc is after the uptime of the box.

David
