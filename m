Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2JMOUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 10:20:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8956 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2JMOUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 10:20:48 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=RHM4pvKubzoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=hedYrj21JNIA:10 a=D19gQVrFAAAA:8 a=9xVraWXGjPlkMXKIgpUA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1350138047.24256.111.camel@gandalf.local.home>
Subject: Re: [PATCH 00/25] asm-generic: Convert all to use Kbuild file
From: Steven Rostedt <rostedt@goodmis.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 13 Oct 2012 10:20:47 -0400
In-Reply-To: <CAHkRjk4D87V9F2-Y5d1A-s+mnt_TpkOSg+dLz6cRtR25aqqoUg@mail.gmail.com>
References: <20121013022632.024527228@goodmis.org>
	 <CAHkRjk4D87V9F2-Y5d1A-s+mnt_TpkOSg+dLz6cRtR25aqqoUg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-13 at 11:17 +0100, Catalin Marinas wrote:
> Hi Steven,
> 
> On 13 October 2012 03:26, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Recently I suggested to someone that was adding a new asm file that
> > currently only contained an x86 change to add a header in all archs
> > that was just a wrapper to point to the asm-generic version. I suggested
> > this because that's the way we use to do it and just to refresh my
> > memory, I looked at div64.h in a few archs and saw that was the case.
> >
> > After having the change done and just after finishing testing it, I was
> > notified that the "proper" way of doing this is to add it to the
> >
> >   arch/*/include/asm/Kbuild
> >
> > file, as 'generic-y += foo.h' and it will reference the asm-generic
> > file automatically. Well it would have been nice if I knew this before
> > and wasn't confused by seeing the incorrect method.
> 
> Since you are  cleaning this up already, could you please merge these
> patches into your series:
> 
> https://lkml.org/lkml/2012/10/11/291
> 
> The first patch adds support for generic-y in the new
> arch/*/include/uapi/asm/Kbuild file, followed by few patches to
> convert three architectures. There will probably be more to convert
> after -rc1.

If the maintainers don't, I'll be happy to take them in too. I can set
up a separate branch for this. I'll see what I can do next week,
although I'll be traveling for the RTLWS.

-- Steve


