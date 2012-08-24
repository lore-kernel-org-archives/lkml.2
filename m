Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2HXQyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:54:52 -0400
Received: from mail1-hoer.fullrate.dk ([89.150.129.84]:60208 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752682Ab2HXQyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:54:49 -0400
From: Martin Nybo Andersen <tweek@tweek.dk>
To: Chris Friesen <chris.friesen@genband.com>
Subject: Re: Drop support for x86-32
Date: Fri, 24 Aug 2012 18:54:45 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc2+; KDE/4.8.4; i686; ; )
Cc: wbrana <wbrana@gmail.com>, Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Ondrej Zary <linux@rainbow-software.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208241814.16862.tweek@tweek.dk> <5037AAB0.6040102@genband.com>
In-Reply-To: <5037AAB0.6040102@genband.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208241854.45656.tweek@tweek.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2012 18:24:16 Chris Friesen wrote:
> On 08/24/2012 10:14 AM, Martin Nybo Andersen wrote:
> > (And I'm still not sure why one would run 32-bit applications on a 64-bit
> > architecture...)
> 
> There are several architectures (powerpc comes to mind) where 32-bit
> userspace on 64-bit kernel is the norm because it offers performance
> advantages due to the smaller pointer size if the process doesn' t need
> the larger address space.  This is the rationale behind the new x32 ABI
> for x86-64 kernels.

For specific cases surely a specific ABI will be faster than another, and 
because of that I love that we are free to choose when using Linux. Personally 
I'd hate maintaining up to three versions of the same userspace code, while 
other might need it (or even do it happily) -- but that is another story.

What I'd hate even more is rendering my old working hardware useless by 
removing x86-32 support from the kernel. To reason the removal by saying 
"Microsoft plans to do it" just makes me go bonkers...

> You might also want to run legacy apps (which can't be recompiled) on
> new hardware.

These legacy apps will most likely be compiled for x86-32 and not x32 (an 
argument for not removing x86-32 support on a running x86-64 kernel).

-- 
Cheers,
Martin
