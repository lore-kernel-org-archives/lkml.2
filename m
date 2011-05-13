Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab1EMJBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:01:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47533 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201Ab1EMJBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:01:45 -0400
Date: Fri, 13 May 2011 11:01:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110513090129.GG13647@elte.hu>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
 <BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
 <BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
 <BANLkTimjHiaZ+b03FLb1LX=ycv=cAVyJZw@mail.gmail.com>
 <20110512213542.GB17596@elte.hu>
 <BANLkTikPmq=NOt-9t0odVVnrRshM=MsnJw@mail.gmail.com>
 <20110512215023.GA20939@elte.hu>
 <20110512220715.GA7451@redhat.com>
 <BANLkTi=EfPMQ4Z7+_SrKAeOYHfDC6t9vyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=EfPMQ4Z7+_SrKAeOYHfDC6t9vyQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> Good point about System.map! Even if /proc/kallsyms contains zero addresses, 
> I can still get them from /boot/System.map which is readable by everyone, I 
> think. It does not contain the modules addresses, but you have the core 
> functions, unless I am somehow mistaken.

Yes. I pointed out this and some other details a couple of months ago, for a 
similarly motivated /proc/kallsyms obfuscation patch:

  http://lkml.org/lkml/2010/11/4/113
  http://lkml.org/lkml/2010/11/4/145

Thanks,

	Ingo
