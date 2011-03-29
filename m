Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab1C2TJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:09:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1C2TJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:09:53 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=QQXixWDqseIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=yf7tFXOqs6SvTWheinQA:9 a=YAE0QbMEHybjuxntPRrWHfnHCoEA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH] lockdep: Print a nice description of an irq
 locking issue
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110329182154.GA18913@elte.hu>
References: <1301418845.14261.284.camel@gandalf.stny.rr.com>
	 <20110329182131.GB16244@elte.hu>  <20110329182154.GA18913@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 29 Mar 2011 15:09:50 -0400
Message-ID: <1301425790.14261.290.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 20:21 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > After having to explain lockdep interrupt locking inversions a few
> > > times, I decided to have lockdep spit out the scenario that it is
> > > complaining about.
> > 
> > Looks very useful!
> > 
> > Would you be interested in extending this to other lockdep splats as well? 

Sure, that should not be a problem.

> 
> In separate patches, of course.

Of course ;)

-- Steve


