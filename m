Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762625Ab0HGNPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 09:15:48 -0400
Received: from ns.store20.com ([212.7.7.16]:39269 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab0HGNPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 09:15:46 -0400
Subject: [BISECTED/2.6.35+] Regression: Machine runs really slowly after
 commit f12a15be
From: Priit Laes <plaes@plaes.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: johnstul@us.ibm.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Aug 2010 16:15:41 +0300
Message-ID: <1281186941.23274.5.camel@chi>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following commit makes my Dell Latitude D610 machine (x86_32) run really-really slow...

f12a15be63d1de9a35971f35f06b73088fa25c3a is the first bad commit
commit f12a15be63d1de9a35971f35f06b73088fa25c3a
Author: John Stultz <johnstul@us.ibm.com>
Date:   Tue Jul 13 17:56:27 2010 -0700

    x86: Convert common clocksources to use clocksource_register_hz/khz
    
    This converts the most common of the x86 clocksources over to use
    clocksource_register_hz/khz.
    
    Signed-off-by: John Stultz <johnstul@us.ibm.com>
    LKML-Reference: <1279068988-21864-11-git-send-email-johnstul@us.ibm.com>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

:040000 040000 264bcae0fcf10c54412a6c9df83b295e8c7e089b 8fc84146e6f34006cca10681afcc9869362a1cfc M	arch
:040000 040000 a5f57efb367b7915d96c50fb123c053e58756423 874a8252ec8f7c9a5422e0b78834981902ad122d M	drivers
