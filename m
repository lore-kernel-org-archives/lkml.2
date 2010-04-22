Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0DVO1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:27:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:59144 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754953Ab0DVO12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:27:28 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18TCioVhQ0TlnnFh9y2yaHC3RVQmmSGtl6LPUC4sA
	vUZiRcOa61xLW5
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Michael Guntsche <mike@it-loops.com>
Subject: Re: Compile error with 2.6.34-rc5+
Date: Thu, 22 Apr 2010 16:27:21 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33-2.slh.8-sidux-686; KDE/4.4.2; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-raid" <linux-raid@vger.kernel.org>
References: <20100422134550.GA4886@gibson.comsick.at>
In-Reply-To: <20100422134550.GA4886@gibson.comsick.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004221627.23600.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 22 April 2010, Michael Guntsche wrote:
> Hi,
> 
> While compiling current git HEAD on one of my boxes I got a compile error.
> Current head is at 1ef6ce7a340f9ed139a73147ff9cf7ad56889414 and the
> compile error is
> 
> drivers/built-in.o: In function `raid5_compute_sector':
> raid5.c:(.text+0x85a36): undefined reference to `__umoddi3'
> raid5.c:(.text+0x85a67): undefined reference to `__umoddi3'
> raid5.c:(.text+0x85a9c): undefined reference to `__umoddi3'
> raid5.c:(.text+0x85acd): undefined reference to `__umoddi3'
> raid5.c:(.text+0x85b23): undefined reference to `__umoddi3'
> drivers/built-in.o:raid5.c:(.text+0x85b54): more undefined references to
> `__umoddi3' follow

This seems to be the same problem as 
	http://lkml.indiana.edu/hypermail/linux/kernel/1004.2/01814.html
fixed in
	http://lkml.indiana.edu/hypermail/linux/kernel/1004.2/01816.html

> The config file was taken straight from a -rc4 kernel and make oldconfig
> was run before that. 
> This runs on/is compiled for a 32bit Pentium IV system so I wonder why umoddi3 is being used.
> 
> Kind regards,
> Michael

Regards
	Stefan Lippers-Hollmann
