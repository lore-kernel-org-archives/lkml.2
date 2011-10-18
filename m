Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab1JRAJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 20:09:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58291 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1JRAJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 20:09:51 -0400
X-Authority-Analysis: v=1.1 cv=cRnbtTsVO6wWDdOYuq0VmyuiiLG/FStMSb4CWlTvuS0= c=1 sm=0 a=rBmysYqC3NUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=D19gQVrFAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=gu6fZOg2AAAA:8 a=uaqxkOghc3esSXJr9hAA:9 a=PUjeQqilurYA:10 a=OUhvLjL00tsA:10 a=U62fhAwekXMA:10 a=UTB_XpHje0EA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318896589.4722.17.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.2] tracing: various fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: David Rientjes <rientjes@google.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 17 Oct 2011 20:09:49 -0400
In-Reply-To: <alpine.DEB.2.00.1110171424270.18439@chino.kir.corp.google.com>
References: <20111017174938.842273454@goodmis.org>
	 <20111017185440.GB5545@elte.hu>
	 <1318878632.4722.6.camel@gandalf.stny.rr.com>
	 <20111017194030.GA6502@elte.hu>
	 <1318881923.4722.11.camel@gandalf.stny.rr.com>
	 <1318882335.4722.13.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1110171424270.18439@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 14:26 -0700, David Rientjes wrote:
> On Mon, 17 Oct 2011, Steven Rostedt wrote:
> 
> > > I could add it, but we should have an Acked-by from Hirokazu Takata.
> > 
> > 
> > Here's the patch I'm referring to:
> > 
> > https://lkml.org/lkml/2011/10/13/259
> > 
> > Thanks!
> > 
> 
> This patch makes my m32r cross-compiler happy, so for that:
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> although the "Link:" field in that patch doesn't work for me.

OK, I'll add it with your Ack and a Cc to Hirokazu.

As for the link, it will work again when kernel.org has that operational
again.

The Link: format is:

Link: http://lkml.kernel.org/r/<message-id>

You can also find this at:

http://marc.info/?i=<message-id>

which would give you:

http://marc.info/?i=20111013085936.GA13046@elte.hu

-- Steve


