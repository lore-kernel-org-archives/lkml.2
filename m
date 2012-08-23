Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab2HWSvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:51:04 -0400
Received: from mail1-hoer.fullrate.dk ([89.150.129.84]:50569 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754566Ab2HWSvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:51:00 -0400
From: Martin Nybo Andersen <tweek@tweek.dk>
To: wbrana <wbrana@gmail.com>
Subject: Re: Drop support for x86-32
Date: Thu, 23 Aug 2012 20:50:57 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc2+; KDE/4.8.4; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208231814.21168.tweek@tweek.dk> <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com>
In-Reply-To: <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com>
MIME-Version: 1.0
X-Length: 2554
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208232050.57668.tweek@tweek.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2012 19:22:07 wbrana wrote:
> x86-32
> - is deprecated since Linux supports X32.
> - will slow down adoption of X32 - there won't be X32 versions of many
> software - if new ABI was added, old one should be removed
> - wastes time of developers who can spend their time supporting X32
> instead of x86-32 or support x86-64 only as 99% of users will be able
> to run x86-64 software if x86-32 will be dropped
> - wouldn't be dropped this year, but there should be plan when it will
> be dropped e.g. when Windows 9 will be released
> 
> On 8/23/12, Martin Nybo Andersen <tweek@tweek.dk> wrote:
> > Why?

I see that you chose to ignore the rest of my mail, which got lost on the way 
to the lkml apparently because it was infected with some HTML:

----
Windows 9 will have no support for Aplha, m68k, risc, PowerPC, SPARC, ESA/390 
to name a few.
 
They could be dropped as well, but why?
----

You could call these architectures deprecated as well. However I like the fact 
that Linux doesn't try to force the users into using some specific hardware 
(or software for that matter), as some companies tend to do.

BTW: This mail is written on an asus eeepc (32-bit intel thing), and my first 
hands-on experience with Linux was on an amiga 1200 (mc68030). Naturally, I 
love the versatility of Linux and see no reason for dropping support for old 
hardware unless, it is _really_ not used anymore (token ring comes to mind).

-- 
Cheers,
Martin
