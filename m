Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2BDPPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 10:15:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2BDPPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 10:15:15 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VjYjH05F8U0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=buDcl2YXr5dIslTPh0MA:9 a=4fFcp_7zPeixjvLFB-AA:7 a=PUjeQqilurYA:10 a=-Kq2HLBH2XRvGPUL:21 a=YHU8BXc-ErAkUPPT:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328368512.5882.215.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][Trivial] Fix up version number reference in
 include/trace/events/power.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Sat, 04 Feb 2012 10:15:12 -0500
In-Reply-To: <4F2C56D9.8010801@linux.intel.com>
References: <alpine.LNX.2.00.1201152146570.13389@swampdragon.chaosbits.net>
	 <1326661784.7642.140.camel@gandalf.stny.rr.com>
	 <alpine.LNX.2.00.1201152210300.13389@swampdragon.chaosbits.net>
	 <alpine.LNX.2.00.1202032241380.25026@pobox.suse.cz>
	 <4F2C56D9.8010801@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 13:51 -0800, Arjan van de Ven wrote:
> On 2/3/2012 1:42 PM, Jiri Kosina wrote:
> > On Sun, 15 Jan 2012, Jesper Juhl wrote:
> > 
> >>>> -/* This code will be removed after deprecation time exceeded (2.6.41) */
> >>>> +/* This code will be removed after deprecation time exceeded (3.1) */
> >>>
> >>> Shouldn't the real fix be to remove this code? What's the use of
> >>> changing the version number that this code will be removed from, when
> >>> the change won't get in until after the version that this code should
> >>> have been removed?
> >>>
> >>> This is like updating 2014 calendars to say the world will end in 2012.
> >>>
> >> Heh, yeah, in a way you are right. But we have lots of code in the kernel 
> >> that says it will be removed at <some date in the past>, so I just figured 
> >> that if this code ends up hanging around it should at least display the 
> >> correct version number for when it /should/ have been removed.
> >> The actual removal I'll leave up to others.
> > 
> > Funny thing. Okay, this doesn't seem to be in linux-next, so I am taking 
> > it.
> > 
> > Steven, planning to drop the code in a near future? :)
> 
> we shouldn't be dropping these yet.. tools are still using them.
> and there really is no cost to keeping them either.

Then the correct fix is to remove the comment, as it is incorrect.

-- Steve


