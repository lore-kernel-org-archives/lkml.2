Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab1KHGhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 01:37:50 -0500
Received: from mamba.nagafix.co.uk ([194.145.196.68]:39960 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751047Ab1KHGht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 01:37:49 -0500
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Nov 2011 01:37:49 EST
Message-ID: <4EB8CBB0.8010201@nagafix.co.uk>
Date: Tue, 08 Nov 2011 13:26:56 +0700
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: 2.6.32.47 breaks UML build (both i386 and amd64)
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(...)
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `sysdev_resume':
/linux-2.6.32.47-amd64/drivers/base/sys.c:478: undefined reference to
`irq_pm_syscore_resume'
collect2: ld returned 1 exit status
  KSYM    .tmp_kallsyms1.S
nm: '.tmp_vmlinux1': No such file
No valid symbol.
make: *** [.tmp_kallsyms1.S] Error 1

Using this config for a 64-bit build:
http://uml.devloop.org.uk/kernels/kernel64-2.6.32.46.config

Note: I only applied the patch to the existing build tree and did not
make clean or make mrproper.
2.6.33.20 is not affected.

Cheers
Antoine
