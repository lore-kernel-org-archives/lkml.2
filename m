Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1KUVLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:11:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41503 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab1KUVLX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:11:23 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Nicolas Kalkhof" <nkalkhof@web.de>
Subject: Re: [REGRESSION] sudden cpu hogging in kernel 3.2 rc-series
Date: Mon, 21 Nov 2011 22:11:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-rc2; KDE/4.6.5; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <506786689.810044.1321648395265.JavaMail.fmail@mwmweb010>
In-Reply-To: <506786689.810044.1321648395265.JavaMail.fmail@mwmweb010>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111212211.17717.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 18 listopada 2011 o 21:33:15 Nicolas Kalkhof wrote:
> Hello,
> 
> since the merges for kernel 3.2 came in late october, my mobile i7 2620M
> sandybridge cpu/gpu seems to run hotter (approx 10 °C) when idling and
> after some minutes according to top the cpu load goes up on all cores but
> the cpu frequency stays low (800 MHz) as well as the gpu (650MHz) and the
> system is responding well. Yet still additional 5-8 watts are continously
> drained from the power supply. Something is throttling up :(. Oprofile
> shows that the kernel hogs the cpu (see dump below). This happens with
> every kernel since the 3.2 merge window closed up to latest linux-next. I
> wasn't able to track the bad commit down yet.
> 
> Could someone please confirm the issue?
> 

I observed similar behaviour, few minutes after boot, when KDE is working 
plasma-desktop process (sometimes another) uses 20-50% cpu. System and kernel 
works without any kernel, but cpu usage is greater than in 3.1 (and older).

Hardware: old hp/compaq nx6310

Add this mail to regression list.

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
