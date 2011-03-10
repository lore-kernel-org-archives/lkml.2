Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1CJSLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:11:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60630 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1CJSLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:11:06 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=XbqWoAS_rckA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=IHIGNWZHcwZ17vCXUZsA:9 a=YkAPOZdnDboL_5ggCgGnMzA4dhUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional
 assignment of CC and AR"
From: Steven Rostedt <rostedt@goodmis.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
In-Reply-To: <4D790F4B.2030908@linux.intel.com>
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>
	 <1299715137-22768-3-git-send-email-dhsharp@google.com>
	 <4D7828F9.7000906@linux.intel.com>
	 <1299720997.15854.276.camel@gandalf.stny.rr.com>
	 <4D783038.8080103@linux.intel.com>
	 <AANLkTikHy1pZP0=cpmSD_HG-jeJvgne3u2ivOif6DHP8@mail.gmail.com>
	 <4D787312.7080609@linux.intel.com>
	 <1299762670.15854.332.camel@gandalf.stny.rr.com>
	 <4D790F4B.2030908@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 13:11:04 -0500
Message-ID: <1299780664.15854.399.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 09:50 -0800, Darren Hart wrote:
> 
> On 03/10/2011 05:11 AM, Steven Rostedt wrote:
> > On Wed, 2011-03-09 at 22:43 -0800, Darren Hart wrote:
> >
> >>> I don't know the answers, but if we take the kernel Makefile as a
> >>> template, then setting CC doesn't work.
> >>
> >> The kernel is a bit special I believe as it is pretty tied to gcc. Is
> >> trace-cmd tied to gcc to such a degree that we want to make it difficult
> >> for people to try different compilers?
> >
> > True, trace-cmd is tied more to glibc (special features) than gcc.
> >
> > I just looked at the Makefile for evolution, and it has:
> >
> > CC = gcc
> >
> > So it is not limited to just the kernel.
> 
> I think we're down to a subjective argument over "correctness".

No no no don't stop! I love having subjective arguments over
"correctness"! ;)


>  Any of 
> the resent proposals will work for me.

OK, personally, I like the last one, even if it is an overkill of
Makefile obfuscation.

David, could you post that last change. I'll add a patch on top
commenting the reason for it, and how Makefile's suck ;)

-- Steve



