Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab0GCWRp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:17:45 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:57700 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab0GCWRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:17:44 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Jul 2010 18:17:44 EDT
Date: Sat, 3 Jul 2010 18:10:57 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: Radeon KMS doesn't work.
Message-ID: <20100703221056.GA17817@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Dell Inspiron 5100 with an ATI Radeon Mobility M7 (7500 R100
PCI ID 1002:4c57 sub 1028:0149).

Immediately when radeon.ko is loaded, the screen goes blank (The backlight
stays on).  I have fbcon compiled into the kernel (I also tried as module). 
I am unable to get the screen to work again until I reboot.  The logs did
not appear to have any errors after the module loaded.  The system was still
responsive on the network.

I tried kernels 2.6.33 and 2.6.34.

I can provide kernel output if needed.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
