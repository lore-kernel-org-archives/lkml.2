Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab2KODD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 22:03:56 -0500
Received: from hosting.visp.net.lb ([194.146.153.11]:33156 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab2KODDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 22:03:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 15 Nov 2012 05:03:48 +0200
From: Denys Fedoryshchenko <denys@visp.net.lb>
To: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Latest 3.6.6 are not compiling due tg3 network driver,
 =?UTF-8?Q?hwmon=5Fdevice=5Funregister?=
Message-ID: <8b566c4a9ee622737212dc17291ee238@visp.net.lb>
User-Agent: VISP Webmail/0.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

During compiling i am getting that:

drivers/built-in.o: In function `tg3_close':
tg3.c:(.text+0x12902e): undefined reference to 
`hwmon_device_unregister'
drivers/built-in.o: In function `tg3_hwmon_open':
tg3.c:(.text+0x12ae09): undefined reference to `hwmon_device_register'

Kernel config are at http://nuclearcat.com/config-tg3.txt  , but i 
noticed this error are appearing at x86, x64 kernels, probably also 
other 3.6.x series kernels.
Disabling TG3 driver helps, but i believe it is not a solution.

---
Denys Fedoryshchenko, Network Engineer, Virtual ISP S.A.L.
