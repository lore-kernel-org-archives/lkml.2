Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0E0FbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:31:08 -0400
Received: from xenotime.net ([72.52.115.56]:51996 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752378Ab0E0FbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:31:06 -0400
Date: Wed, 26 May 2010 22:31:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Message-Id: <20100526223101.3f2dd7dd.rdunlap@xenotime.net>
In-Reply-To: <20100527043123.GA5349@cr0.nay.redhat.com>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
	<201005270213.42913.rjw@sisk.pl>
	<AANLkTil180tPW4KoOaUBgXIm1Lf6O45_GKKlLx3CDcVh@mail.gmail.com>
	<20100527043123.GA5349@cr0.nay.redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 12:31:23 +0800 Américo Wang wrote:

> On Thu, May 27, 2010 at 09:39:51AM +0530, Jaswinder Singh Rajput wrote:
> >Hello Rafael,
> >
> >On Thu, May 27, 2010 at 5:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> On Thursday 27 May 2010, Jaswinder Singh Rajput wrote:
> >>> Hello,
> >>>
> >>> I am trying to build 32 bit kernel image on 64-bit machine but after
> >>> 'make menuconfig' it automatically switches 32-bit to 64-bit.
> >>
> >> Try 'linux32 make menuconfig' and 'linux32 make'.
> >>
> >
> >Yes, this works :-)
> 
> 
> I think 'make ARCH=i386 menuconfig' also works.

Yes, that's what I use.  I wasn't familiar with the "linux32 make ..." usage.


> >But I wonder then what is the point/use of CONFIG_X86_32 if compiler
> >is not listening to it.
> >
> >Logically compiler should set appropriate flags based on .config settings.
> >
> 
> It's not compiler, it's kbuild, kbuild tries to determine the arch
> by 'uname -m'.
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
