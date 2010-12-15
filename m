Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab0LOWZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:25:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58136 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab0LOWZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:25:50 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=bLmJrh3I8mQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=rOUgymgbAAAA:8 a=D19gQVrFAAAA:8 a=l0BGnYWgph-KsVvwJcwA:9 a=oHc7uLkC02BaH_EAkVQA:7 a=EYYRtAOnwl5Sis2nJdYilFM-paoA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: ftrace/MIPS related x86_64 build failure on in Linus' tree
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnaud Lacombe <lacombar@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        John Reiser <jreiser@bitwagon.com>, Wu Zhangjin <wuzhangjin@gmail.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101216090019.639191a1.sfr@canb.auug.org.au>
References: <20101215160440.bafbe38c.sfr@canb.auug.org.au>
	 <AANLkTimgNVUaQcRdva_usq1XX=vp1xwHM3rUeT_hNCZd@mail.gmail.com>
	 <20101216090019.639191a1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 15 Dec 2010 17:25:36 -0500
Message-ID: <1292451936.5015.1905.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 09:00 +1100, Stephen Rothwell wrote:
> Hi Arnaud,
> 
> On Wed, 15 Dec 2010 01:45:45 -0500 Arnaud Lacombe <lacombar@gmail.com> wrote:
> >
> > On Wed, Dec 15, 2010 at 12:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > Since October 31 our x86_64 allmodconfig builds have been failing like this:
> > >
> > > /opt/crosstool/gcc-4.4.3-nolibc/x86_64-linux/bin/x86_64-linux-ld: arch/x86/ia32/sys_ia32.o: bad reloc symbol index (0x1000000 >= 0x6b) for offset 0x808080 in section `__mcount_loc'
> > > arch/x86/ia32/sys_ia32.o: could not read symbols: Bad value
> > >
> > I got the same on mips, target was BE, toolchain's host was LE.
> > Doesn't https://lkml.org/lkml/2010/12/2/224 address the issue ? This
> > patch does not seem to have reached Linus tree yet.
> 
> Thanks for pointing that out.  I wonder how we can push that along.

I did some poking, it should be moving along soon.

Thanks!

-- Steve


