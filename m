Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab1CaD3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 23:29:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53111 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab1CaD3j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 23:29:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SO/xCX9VzQrUCn7uSqMGyMduq4fUSHDoE47jNlQDzTS+3I+U2vfi/0PQkXVwkPvGZP
         U6nU43MyA0TtBzKwmTAhav0XYjHhitDIh/mI9KDPPX+sRuTNJSfogA/GDgUXFQ+e04SK
         pDQ6+xXY1n8M5NKbyhnSgWqOe4q6+b9zmGLIU=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103302255280.28032@xanadu.home>
References: <20110317183048.GW7258@atomide.com>
	<AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
	<20110318101512.GA15375@n2100.arm.linux.org.uk>
	<201103301906.42429.arnd@arndb.de>
	<AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
	<alpine.LFD.2.00.1103301531420.28032@xanadu.home>
	<AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
	<alpine.LFD.2.00.1103301814250.28032@xanadu.home>
	<alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
	<alpine.LFD.2.00.1103302255280.28032@xanadu.home>
Date: Thu, 31 Mar 2011 13:29:38 +1000
Message-ID: <AANLkTikV5OMifKjWRVdtJLEcxcZ56jrjWLYJBX89pHQ0@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Dave Airlie <airlied@gmail.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As long as SOC vendors keep producing wildly different architectures
> besides the core CPU we'll have this problem.  Denying the reality won't
> make that problem go away either.  And device tree won't stop those
> vendor from still trying to do things differently (better?) because they
> are not constrained by having to ensure this single proprietary software
> stack still boot.

So you are saying the only way to get the Linux ARM shit cleaned up is
to hope Microsoft succeeds in making Windows a success on ARM?

Dave.
