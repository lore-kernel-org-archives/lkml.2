Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab0IWRC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:02:27 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:10928 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab0IWRCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:02:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19611.34846.813757.309183@pilspetsen.it.uu.se>
Date: Thu, 23 Sep 2010 19:02:22 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: sparclinux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.36-rc regression] occasional complete system hangs on sparc64 SMP
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my Sun Blade 2500 (2 CPUs), post 2.6.35 kernels sometimes hang
completely without visible messages on either the console or in
the kernel logs.

The first two times (with -rc1 or -rc3) it happended during gcc
bootstraps + regression test runs, today (with -rc4) it happended
while compiling the 2.6.36-rc5 kernel.  It's very sporadic, perhaps
one of ten boots will eventually hang like this.

With 2.6.35 the machine is rock solid.

The 2.6.36-rc kernels do appear to be solid on a UP Ultra5, but that
one no longer does any gcc builds or tests, only kernel builds.

Any ideas, or do I have to try to bisect this?

/Mikael
