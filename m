Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab0IWUho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:37:44 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:49166 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab0IWUhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:37:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19611.47764.491500.541850@pilspetsen.it.uu.se>
Date: Thu, 23 Sep 2010 22:37:40 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: HPET broken again/still in 2.6.36-rc5?
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just had a weird partial hang with 2.6.36-rc5 on x86.
I was trying to start a new xterm but it just wouldn't
appear on the screen.  I then noticed that a gcc build
in one xterm had frozen.  Running dmesg in yet another
xterm hanged.

Meanwhile I had no problems shifting focus between windows,
or typing commands in ssh connections to other machines.

After about two minutes the hanging operations suddenly
resumed without errors, and the following was at the end
of the kernel log:

CE: hpet increased min_delta_ns to 7500 nsec

The machine is a Core i7 with X58 chipset.
