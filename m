Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab0J1Vhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:37:52 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:39186
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756714Ab0J1Vhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:37:46 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Oct 2010 17:37:45 EDT
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh2a8h66h)
X-Spam-TCS-SCL: 5:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
Message-ID: <4CC9E99A.3070903@freescale.com>
Date: Thu, 28 Oct 2010 16:22:34 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.13) Gecko/20101013 Fedora/2.0.8-2.fc13 SeaMonkey/2.0.8
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Typo in tty_driver.h?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2010 21:23:06.0378 (UTC) FILETIME=[4FD006A0:01CB76E6]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe I found a typo in a comment in tty_driver.h

 * TTY_DRIVER_DYNAMIC_DEV --- if set, the individual tty devices need
 *	to be registered with a call to tty_register_driver() when the
 *	device is found in the system and unregistered with a call to
 *	tty_unregister_device() so the devices will be show up
 *	properly in sysfs.  If not set, driver->num entries will be
 *	created by the tty core in sysfs when tty_register_driver() is
 *	called.  This is to be used by drivers that have tty devices
 *	that can appear and disappear while the main tty driver is
 *	registered with the tty core.

On line 2, I think it should say "tty_register_device()" instead of
"tty_register_driver()".

-- 
Timur Tabi
Linux kernel developer at Freescale

