Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab1E1Uf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 16:35:27 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:36006 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1E1Uf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 16:35:26 -0400
From: Markus <M4rkusXXL@web.de>
To: lkml <linux-kernel@vger.kernel.org>
Subject: 2.6.39 hangs on boot
Date: Sat, 28 May 2011 22:35:24 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.2-gentoo-ck1; KDE/4.6.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105282235.24530.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX18p/YO2DS/e2Fe7tMOe4Pb+6s0p16BxGLrjliJR
	5o5OYUuM5cj8gYh8c6Y8hoXjCgpR21bjpJpURNiExqeCEm58sM
	2xAjoTS/g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I tried the vanilla 2.6.39 today, but it doesnt even boot. The last 
lines I see are:
Refined TSC clocksource calibration: 3210.779 MHz.
Switching to clocksource tsc

After that nothing more happens. After a minute I rebooted into a 2.6.38 
kernel, it worked:
$ dmesg | grep clocksource
Switching to clocksource hpet
Refined TSC clocksource calibration: 3210.778 MHz.
Switching to clocksource tsc


Issue known? Any patch/workaround? How could I help?


Markus

PS: Please CC me.
