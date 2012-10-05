Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab2JERqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:46:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30802 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab2JERql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:46:41 -0400
X-Authority-Analysis: v=2.0 cv=fb8vOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_Ld--4Lr3LMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=t9ydKhIB5vYA:10 a=pGLkceISAAAA:8 a=TzeAaOVhAAAA:8 a=vikj0InrG-HBPknX5aYA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=UVEM-Fm2KIoA:10 a=VQ7OGjdcjMoYM5RE:21 a=TrR0jtbbByy9Wq9i:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349459199.6755.66.camel@gandalf.local.home>
Subject: Re: [PATCHv2.5] trace: reuse kbasename() functionality
From: Steven Rostedt <rostedt@goodmis.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 05 Oct 2012 13:46:39 -0400
In-Reply-To: <CAHp75Vcvw-uc+2srSSTrdcUqU_rTsMS5k7cLrvkRtiLve6aNvw@mail.gmail.com>
References: <1349253783-21612-7-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1349254399-22742-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1349455743.6755.57.camel@gandalf.local.home>
	 <CAHp75Vc1a-4LtuTun=urBLvroLqsok4zeW-Fqm-uDK9izmsR6w@mail.gmail.com>
	 <1349457161.6755.61.camel@gandalf.local.home>
	 <CAHp75Vcvw-uc+2srSSTrdcUqU_rTsMS5k7cLrvkRtiLve6aNvw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 20:21 +0300, Andy Shevchenko wrote:
> On Fri, Oct 5, 2012 at 8:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Fri, 2012-10-05 at 20:02 +0300, Andy Shevchenko wrote:
> >
> >> > I don't see kbasename() anywhere. Is this based off of other patches?
> >> It's introduced by first patch in the series.
> > Usually a series has the format of:
> >
> > [PATCH x/n] ....
> >
> > Where x is the patch number and n is the total number of patches. I'm
> > not sure what a v2.5 is. This is version 2 and a half?
> Ah, it's an update to patch 6/6. You could see it by
> Message-Id/In-Reply-To chains.
> 

OK, that's where the confusion stems from. The original patch 6/6 had in
the patch:

Cc: Steven Rostedt <rostedt@goodmis.org> (maintainer:TRACING)                                                                                                                       
Cc: Frederic Weisbecker <fweisbec@gmail.com> (maintainer:TRACING)

But I neither I nor Frederic were on the actual Cc (I had to open my
LKML folder to see it). Perhaps whatever tool you used to send the
patches got confused by the (maintainer:TRACING) line.

Thus, the only thing that ended up in my INBOX was the [PATCHv2.5] one.

-- Steve


