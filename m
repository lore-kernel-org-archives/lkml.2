Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab1CDOhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:37:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48194 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758466Ab1CDOhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:37:20 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=_RNfGJhW_G8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=JeQ7r8q9cwzjBT4CA48A:9 a=mM7byUpeoS-IoAoS_w1U_bSma44A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] perf lock: clean the options for perf record
From: Steven Rostedt <rostedt@goodmis.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <4D70B3E1.8020108@dcl.info.waseda.ac.jp>
References: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <4D63D685.2010401@dcl.info.waseda.ac.jp> <1298389415.2217.243.camel@twins>
	 <20110222182206.GB1799@nowhere> <4D648A65.2040107@dcl.info.waseda.ac.jp>
	 <4D667D60.5010903@dcl.info.waseda.ac.jp> <20110224165014.GB1840@nowhere>
	 <4D67E286.8010907@dcl.info.waseda.ac.jp>
	 <AANLkTikUGO=Obm7Ue4VzEueQ7DERPiwci1VV9NmKZf1u@mail.gmail.com>
	 <4D70B3E1.8020108@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 04 Mar 2011 09:37:18 -0500
Message-ID: <1299249438.20306.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 18:41 +0900, Hitoshi Mitake wrote:

> BTW, how do you think about the idea of exporting data in
> python (or other neutral) expression from procfs? I feel it is a
> good idea. Communicating with unified format between user space and
> kernel space will reduce lots of parsing overhead. Is this too
> aggressive or insane?

As I mentioned in another email, I have no problem with an easy to parse
file. But I will aggressively NAK any "python" or other scripting
language. I'm sure I would get the same response if I were to have the
kernel outputting perl language ;)

I would be OK if we have two files similar to stat and status, where one
format is human readable, the other is for parsing.

Thus, the only acceptable language that should come out of the kernel is
English.

-- Steve


