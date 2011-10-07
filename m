Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1JGUA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:00:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51884 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab1JGUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:00:26 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=5E__mjtSOyIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=3Ogy38lQgbLud3jf1FQA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH] kbuild: let object files depend on recordmcount instead
 of its sources
From: Steven Rostedt <rostedt@goodmis.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Fri, 07 Oct 2011 16:00:25 -0400
In-Reply-To: <20111007194750.GX6949@pengutronix.de>
References: <1317993561-16242-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <20111007194750.GX6949@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 8bit
Message-ID: <1318017625.4729.80.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 21:47 +0200, Uwe Kleine-König wrote:

> I could reproduce the build failure Steve is seeing now (enabling
> CONFIG_FUNCTION_TRACER helps, stupid me). I think the problem is that
> with my change empty.o depends on recordmcount and in a way that I don't
> understand recordmcount depends on empty.o. I wonder if it's possible to
> get rid of the latter dependency?!

It may be possible but probably not worth it. When I stumbled on empty.o
I talked with some of the kbuild folks, and IIRC, it is pretty core to
the dependency structure. Changing it may break other things easily.

-- Steve


