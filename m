Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab2BWRKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:10:50 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55503 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753665Ab2BWRKt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:10:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.182.38.3 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120223165302.GG25177@infradead.org>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
	<20120223162850.GC25177@infradead.org>
	<CAOJsxLG2c=Mc-Rn56jmB290LtHpRY8pkfyqPrizgwE8_8+uxFQ@mail.gmail.com>
	<20120223163938.GD25177@infradead.org>
	<1330015504.13624.84.camel@jaguar>
	<20120223164739.GF25177@infradead.org>
	<20120223165302.GG25177@infradead.org>
Date: Thu, 23 Feb 2012 19:10:48 +0200
X-Google-Sender-Auth: snzJ8GazGzRX6JjoCj8s1IAYCFc
Message-ID: <CAOJsxLGP97smBEshzMY1vKMbSiK-mP1+dK8czuFM3girq-KS+A@mail.gmail.com>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report' browser
From: Pekka Enberg <penberg@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 6:53 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Thu, Feb 23, 2012 at 02:47:39PM -0200, Arnaldo Carvalho de Melo escreveu:
>> Em Thu, Feb 23, 2012 at 06:45:04PM +0200, Pekka Enberg escreveu:
>> > On Thu, 2012-02-23 at 14:39 -0200, Arnaldo Carvalho de Melo wrote:
>> > > > Dunno, probably. Does that matter, though? It's pretty damn fast as-is.
>> > >
>> > > Well, what kinds of perf.data file are you feeding it?
>> >
>> > It's a real-world case where I'm profiling JRuby startup under Jato with
>> > perf:
>> >
>> > penberg@jaguar:~/src/jato$ ls -lh perf.data
>> > -rw------- 1 penberg penberg 453K 2012-02-23 18:06 perf.data
>> >
>> > On Thu, 2012-02-23 at 14:39 -0200, Arnaldo Carvalho de Melo wrote:
>> > > I'm testing it now with large ones, lets see.
>> >
>> > How big files are we talking about here?
>>
>> 5 MB ones, say.
>
> Nah:
>
> [root@felicio linux]# perf record -a -F 10000 sleep 5m
> [ perf record: Woken up 166 times to write data ]
> [ perf record: Captured and wrote 42.104 MB perf.data (~1839573 samples)
> ]
> [root@felicio linux]#
> [root@felicio linux]#
> [root@felicio linux]# perf report --gtk
>
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 10618 root      20   0  408m 170m  49m S  0.0  2.2   0:04.71 perf
>
> [root@felicio linux]# perf report --tui
>
> 10633 root      20   0  379m 165m  45m S  0.0  2.1   0:01.15 perf

Sorry, I don't understand how to interpret your numbers.

I used the same "perf record" command here which generated a 26 MB
perf.data file. "perf report --gtk" starts up almost instantly here.

                                Pekka
