Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab2J3Sfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:35:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2J3Sff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:35:35 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=V3PaAaPhDywA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=MpoW4NFLMuQA:10 a=Ev6e3Ck_rFUU5JYsq8MA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351622134.4004.17.camel@gandalf.local.home>
Subject: Re: [PATCH] scripts/recordmcount.pl: Support build with
 -ffunction-sections.
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 30 Oct 2012 14:35:34 -0400
In-Reply-To: <CAFbHwiSwGc8g7AV5mKic3JPDktFHw0pE7kR4yXRYoL_Jsyz6fQ@mail.gmail.com>
References: <CAFbHwiRtBaHkpZqTm6VZ=fCJcyu+dsdpo_kxMHy1egce=rTuyA@mail.gmail.com>
	 <1351609517.8467.85.camel@gandalf.local.home>
	 <CAFbHwiRXzWpKjtu2jQzr_COuSLg=HNit-CfkTuArrzc+xP53Og@mail.gmail.com>
	 <1351613128.8467.109.camel@gandalf.local.home>
	 <CAFbHwiSwGc8g7AV5mKic3JPDktFHw0pE7kR4yXRYoL_Jsyz6fQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 17:43 +0000, Will Newton wrote:

> Ok, well we are only concerned with C compiled code, otherwise there
> would be no calls to mcount? The only way I can think of to cause code
> to be emitted in a section of this type is to use the section
> attribute. A quick grep for __attribute__(__section__ or __section
> does not turn up any sections that are named .text.* on any
> architecture (freed or not).
> 
> Is there any other case I have missed? I also did a grep for .text.
> more generally and didn't see anything that looked problematic
> (although it is mainly .S files so not relevant).

If you feel confident enough, then I'm fine with it. But if any more
network cards get bricked, I'm blaming you.

 ;-)

> 
> >>
> >> > Second, most archs today do not use recordmcount.pl. They use the new
> >> > recordmcount.c file.
> >>
> >> Ok, thanks for letting me know. Is the plan to switch over to
> >> recordmcount.c exclusively at some point?
> >
> > When all the archs convert.
> 
> I'll rework my patch against recordmcount.c once I have it working.

OK, thanks.

-- Steve


