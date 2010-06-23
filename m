Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab0FWHBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 03:01:30 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39569 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0FWHB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 03:01:28 -0400
Date: Wed, 23 Jun 2010 00:01:25 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: Yama LSM
Message-ID: <20100623070125.GI5876@outflux.net>
References: <20100621213424.GG24749@outflux.net>
 <201006220028.o5M0Sbx7062650@www262.sakura.ne.jp>
 <20100622011452.GN24749@outflux.net>
 <4C20ABC0.5050908@nokia.com>
 <20100622160613.GC5876@outflux.net>
 <4C21A39C.6040406@ontolinux.com>
 <20100623062242.GG5876@outflux.net>
 <4C21AD07.5050201@ontolinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C21AD07.5050201@ontolinux.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 08:43:19AM +0200, Christian Stroetmann wrote:
> On 23.06.2010 08:22, Kees Cook wrote:
> >On Wed, Jun 23, 2010 at 08:03:08AM +0200, Christian Stroetmann wrote:
> >>"You've already had those suggestions some days ago. Use a security
> >>module, either by using something like SELinux (where you can do
> >>this just fine as far as I can see including exceptions by label for
> >>problem apps)", [Alan Cox, 2010-06-08], or integrate it into an
> >>already existing solution eg. grsecurity (www.grsecurity.net).
> >You appear to be quoting[1], but you left off a bit.  To edit it a bit:
> >
> >   "Use a security module, either by using something like SELinux (...),
> >   or write your own little security module that does it."
> >
> >I have done the latter.
> >
> >I don't need to integrate this into grsecurity because grsecurity already
> >has these protections.  It is Openwall and grsecurity that I'm using as the
> >starting point for this attempt at upstreaming the protections.
> 
> So, this sounds as if you are porting functionalities from
> grsecurtiy into LSM. But [1].
> [1] http://www.grsecurity.net/lsm.php

grsecurity is not in mainline.  I want a few specific features but not the
entire patchset, therefore, I must port functionalities from grsecurity
into mainline.  Since these features have been rejected from the core, they
must go into an LSM.  Luckily for me, there are hooks to handle the 3
protections I am currently interested in.  :)

If you can, please come to the Linux Security Summit[1], where things
like the future of LSM will be discussed.

-Kees

[1] https://security.wiki.kernel.org/index.php/LinuxSecuritySummit2010/Schedule

-- 
Kees Cook
Ubuntu Security Team
