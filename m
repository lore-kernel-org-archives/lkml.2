Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab2EWOhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:37:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7232 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2EWOhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:37:09 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_2gBi4Ny9w4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=bcXUtIwdAAAA:8 a=HHRUVK1QaZg66wTMDnoA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337783828.13348.158.camel@gandalf.stny.rr.com>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 23 May 2012 10:37:08 -0400
In-Reply-To: <1334767425.28106.43.camel@gandalf.stny.rr.com>
References: <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
	 <20120418022705.GA23877@home.goodmis.org>
	 <20120418031557.GA29828@redhat.com>
	 <1334720611.28106.25.camel@gandalf.stny.rr.com>
	 <20120418035004.GA31465@redhat.com>
	 <1334721441.28106.28.camel@gandalf.stny.rr.com>
	 <20120418040632.GB31465@redhat.com>
	 <1334722164.28106.31.camel@gandalf.stny.rr.com>
	 <20120418135815.GA10798@redhat.com>
	 <1334760965.28106.39.camel@gandalf.stny.rr.com>
	 <20120418153002.GB17558@redhat.com>
	 <1334767425.28106.43.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 12:43 -0400, Steven Rostedt wrote:
> On Wed, 2012-04-18 at 11:30 -0400, Dave Jones wrote:
> > On Wed, Apr 18, 2012 at 10:56:05AM -0400, Steven Rostedt wrote:
> >  > On Wed, 2012-04-18 at 09:58 -0400, Dave Jones wrote:
> >  > 
> >  > >  > OK, function tracing is broken on your box. Could you send me your full
> >  > >  > config and I'll take a look at it tomorrow. Bed time for me now ;-)
> >  > > 
> >  > > http://fpaste.org/b8PN/raw/
> >  > 
> >  > Hmm, I had no problems with this config. But that wasn't on my Xeon. I'm
> >  > compiling for that box now.
> >  > 
> >  > Could you also paste your full dmesg.
> > 
> > Oh, I guess it's this..
> > 
> > "PEBS disabled due to CPU errata."
> > 
> > Crap. Never even noticed that before.
> 
> Yeah, but that shouldn't stop the function tracer from working.
> 

Hi Dave,

Have we ever figured out why this wasn't working? Did it start working
on newer kernels?

-- Steve


