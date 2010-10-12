Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab0JLRmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 13:42:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42202
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757306Ab0JLRmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 13:42:16 -0400
Date: Tue, 12 Oct 2010 10:42:38 -0700 (PDT)
Message-Id: <20101012.104238.104051243.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.36-rc regression] occasional complete system hangs on
 sparc64 SMP
From: David Miller <davem@davemloft.net>
In-Reply-To: <19624.63312.156073.410319@pilspetsen.it.uu.se>
References: <19611.34846.813757.309183@pilspetsen.it.uu.se>
	<19624.63312.156073.410319@pilspetsen.it.uu.se>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Sun, 3 Oct 2010 23:36:16 +0200

> I've been testing older kernels and can now say that 2.6.35-git5
> and newer kernels are definitely affected, but 2.6.35-git4 seems
> solid.  I'll dig deeper into the .35-git4->git5 changes towards
> the end of next week.
> 
> I never got any data out of sysrq-y or any other sysrq when a hang
> occurs; usually they'd just print the name of the command but no data,
> sometimes they'd oops and crash the kernel even harder.

So I haven't been ignoring this report, but I cannot reproduce
it on the SB2500 I have access to right now.

I've been doing gcc builds and testsuite runs in a loop for
several days.

Occaisionally I get a dying 'as' which I have seen before and
plan to investigate, but no hard hangs and no crashes.

I'll keep prodding, but if you can narrow it down further
please let us know.
