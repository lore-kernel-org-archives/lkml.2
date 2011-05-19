Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab1ESNbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:31:44 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46838 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab1ESNbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinXQvrG3LeSEO9Lnam3Bvq3dDKOsw@mail.gmail.com>
References: <201105181047.17309.arnd@arndb.de>
	<BANLkTim_0eRvDkQwAYjTNQsOVQiHV+DdBQ@mail.gmail.com>
	<alpine.LFD.2.00.1105182234130.14430@xanadu.home>
	<BANLkTinXQvrG3LeSEO9Lnam3Bvq3dDKOsw@mail.gmail.com>
Date: Thu, 19 May 2011 15:31:42 +0200
Message-ID: <BANLkTi=OdvDT6MEk-RxiTNnX-rbwTOqrrw@mail.gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 5:01 AM, Barry Song <21cnbao@gmail.com> wrote:

> i asked this because we wanted to send the source codes of
> CSR(http://www.csr.com) to upstream as i have told you in LDS. it
> looks like we need to follow the below new changes to make our source
> codes acceptable?
> 1. arm device tree
> 2. new pinmux framework from Linus Walleij

I'm working on that to post a new v3 of this patch set ASAP, if the
ARM subarch tree maintainers are interested I can send them a
pull request after that.

Yours,
Linus Walleij
