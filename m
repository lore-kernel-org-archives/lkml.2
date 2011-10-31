Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1JaDTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 23:19:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60975 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1JaDTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 23:19:20 -0400
Date: Mon, 31 Oct 2011 11:19:07 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Re: HT (Hyper Threading) aware process scheduling doesn't work
 as it should
Message-ID: <20111031031907.GB18057@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
 <20111030151256.27b2b20e@infradead.org>
 <1179048211.51348.1320013764432.JavaMail.mail@webmail17>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1179048211.51348.1320013764432.JavaMail.mail@webmail17>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 30, 2011 at 10:29:23PM +0000, Artem S. Tashkinov wrote:
> > On Oct 31, 2011, Arjan van de Ven wrote:
> >
> > On Sun, 30 Oct 2011 19:57:12 +0000 (GMT)
> > "Artem S. Tashkinov" wrote:
> >
> > > Hello,
> > >
> > > It's known that if you want to reach maximum performance on HT
> > > enabled Intel CPUs you should distribute the load evenly between
> > > physical cores, and when you have loaded all of them you should then
> > > load the remaining virtual cores.
> >
> > this is a bold statement, and patently false if you have to threads of
> > one process that heavily share data between eachother...
> > (but true for more independent workloads)
> 
> In my initial message I was talking about completely unrelated tasks/
> processes which share no data/instructions/whatever else. You don't
> need to trust my test case as you can carry out this test on your own.

(Cc'ing more people)

Maybe you can also show your test case here?

Thanks,
Yong
