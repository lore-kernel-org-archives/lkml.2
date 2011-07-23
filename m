Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1GWOk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 10:40:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56433 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1GWOkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 10:40:53 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.0-rt1
Date: Sat, 23 Jul 2011 16:29:24 +0200
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <alpine.LFD.2.02.1107222203400.2702@ionos>
In-Reply-To: <alpine.LFD.2.02.1107222203400.2702@ionos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107231629.25322.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

on ARM (in this case a Samsung S3C2440 based platform) I get:

kernel/built-in.o: In function `vprintk':
/home/jb/[...]/linux-3.0/kernel/printk.c:862: undefined reference to `early_vprintk'
kernel/built-in.o: In function `register_console':
/home/jb/[...]linux-3.0/kernel/printk.c:1580: undefined reference to `early_console_initialized'
make[1]: *** [vmlinux] Error 1

Did I forget something to enable in my kernel config?

jbe

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | http://www.pengutronix.de/  |
