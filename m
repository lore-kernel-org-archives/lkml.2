Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab1FMXGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:06:30 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:52216 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753009Ab1FMXG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:06:27 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: problems with mtp , better to make a command-line option to
 can switch off mtp device search on booting
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Mon, 13 Jun 2011 19:06:22 -0400
Message-ID: <web-546810453@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get yesterday an acer laptop with big problems to 
install Linux

booting stopped with error messages like:

physmap_flash.0 failed claim ressource 0

L440GX flash mapping failed to find PIIX4 ISA bridge, 
cannot continue

Then the computer stopped, but not crashed, the cursor 
stopped to blink, but reboot
with CTRL-ALT-DEL didn't work, one had to press the reboot 
button

I recompiled the kernel with all MTP things switched off, 
and that booted.

However, normally it should be compiled everything in the 
kernel, and the kernel
during booting should manage it to see and to use what is 
existent in the computer
of the user, without to stick or to crash.

Probably that is an error already sine time in the kernel, 
not a recent regression.

Better to make a command-line option to can switch off mtp 
device search on booting

wl


=================================================
I have problems to post something from my home computer 
site  guyane.yi.org or SYS-Linux.yi.org :

Deferred: 451 4.7.1 Hello [93.121.138.180], for recipient 
address the policy analysis reported: Greylisted, see 
http://isg.ee.ethz.ch/tools/postgrey/help/vger.kernel.org.html
---
Professional hosting for everyone - http://www.host.ru
