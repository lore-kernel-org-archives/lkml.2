Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1AZAFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 19:05:19 -0500
Received: from smtp14.ono.com ([62.42.230.176]:27403 "EHLO resmaa14.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751827Ab1AZAFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 19:05:19 -0500
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jan 2011 19:05:18 EST
Date: Wed, 26 Jan 2011 00:59:31 +0100
From: "J.A. =?ISO-8859-1?B?TWFnYWxs824=?=" <jamagallon@ono.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: WiFi USB key
Message-ID: <20110126005931.59fce843@werewolf.home>
X-Mailer: Claws Mail 3.7.8cvs33 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

I have a brand new usb wifi adapter:

Belkin Surf USB Micro Adapter
Realtek RTL8188CE-VAU: Single-Chip IEEE 802.11b/g/n 1T1R WLAN Controller

Bus 001 Device 003: ID 050d:1102 Belkin Components

In RealTek site the drivers for other 8188 models are really the ones for
8192. I have tried with in-kernel r8192u_usb, but I think I have no luck, 
I see no 'wlan0' under /sys/class/net.

I suppose it is because the module does not recognize the USB IDs in my
device. How can I force it to try without recompiling kernel ?
Is there any parameter o alias in modprobe.conf I could try ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
