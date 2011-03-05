Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1CEROc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:14:32 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52246 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1CEROb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:14:31 -0500
Message-ID: <4D726F6D.4000909@dcl.info.waseda.ac.jp>
Date: Sun, 06 Mar 2011 02:14:21 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b10pre) Gecko/20110114 Thunderbird/3.3a2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf lock: clean the options for perf record
References: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp>  <4D63D685.2010401@dcl.info.waseda.ac.jp> <1298389415.2217.243.camel@twins>  <20110222182206.GB1799@nowhere> <4D648A65.2040107@dcl.info.waseda.ac.jp>  <4D667D60.5010903@dcl.info.waseda.ac.jp> <20110224165014.GB1840@nowhere>  <4D67E286.8010907@dcl.info.waseda.ac.jp>  <AANLkTikUGO=Obm7Ue4VzEueQ7DERPiwci1VV9NmKZf1u@mail.gmail.com>  <4D70B3E1.8020108@dcl.info.waseda.ac.jp> <1299249438.20306.3.camel@gandalf.stny.rr.com>
In-Reply-To: <1299249438.20306.3.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年03月04日 23:37, Steven Rostedt wrote:
> On Fri, 2011-03-04 at 18:41 +0900, Hitoshi Mitake wrote:
>
>> BTW, how do you think about the idea of exporting data in
>> python (or other neutral) expression from procfs? I feel it is a
>> good idea. Communicating with unified format between user space and
>> kernel space will reduce lots of parsing overhead. Is this too
>> aggressive or insane?
>
> As I mentioned in another email, I have no problem with an easy to parse
> file. But I will aggressively NAK any "python" or other scripting
> language. I'm sure I would get the same response if I were to have the
> kernel outputting perl language ;)
>
> I would be OK if we have two files similar to stat and status, where one
> format is human readable, the other is for parsing.
>
> Thus, the only acceptable language that should come out of the kernel is
> English.
>
> -- Steve
>
>
>

OK. As you say, the big confusion might be occur if there are lots of
format like python or perl (and they have several versions).

The reason why I posted the patch is that I like the idea of
/proc/config.gz. Providing the data from kernel in specific syntax
is so smart, so I followed it :)
