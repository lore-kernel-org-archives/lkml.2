Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab0J3DGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 23:06:53 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:43745 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752369Ab0J3DGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 23:06:50 -0400
From: Rupjyoti Sarmah <rsarmah@apm.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Act3331keWjsN/sHTZGScnUum3AwDw==
Date: Sat, 30 Oct 2010 08:36:47 +0530
Message-ID: <6631e123845856ac20423c25e07844c8@mail.gmail.com>
Subject: All Applied micro boards are failing with current mainline kernel
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

APM boards Canyonlands/Kilauea/Glacier/Katmai/Sequoia are all failing
during booting.

Call trace is same for all


Call Trace:

[df835d70] [c02d27cc] emac_probe+0xf28/0x12a8 (unreliable)

[df835e50] [c023c7cc] platform_driver_probe_shim+0x40/0x54

[df835e60] [c01bf354] platform_drv_probe+0x20/0x30

[df835e70] [c01bde68] driver_probe_device+0x148/0x1ac

[df835e90] [c01be17c] __driver_attach+0xa4/0xa8

[df835eb0] [c01bcfa4] bus_for_each_dev+0x60/0x9c

[df835ee0] [c01bdbbc] driver_attach+0x24/0x34

[df835ef0] [c01bd94c] bus_add_driver+0x1b8/0x274

[df835f20] [c01be3d8] driver_register+0x6c/0x160

[df835f40] [c01bf6c4] platform_driver_register+0x68/0x78

[df835f50] [c023c998] of_register_platform_driver+0xa8/0xc4

[df835f60] [c0393e88] emac_init+0x1ac/0x1dc

[df835fa0] [c0001574] do_one_initcall+0x160/0x1a8

[df835fd0] [c037a1e8] kernel_init+0xcc/0x174

[df835ff0] [c000c5b0] kernel_thread+0x4c/0x68

Instruction dump:

419e016c 2f800007 419e0164 38130774 901a00d0 381306b0 901a00d4 7f43d378

4bf91d89 817a01a0 39200001 380b0008 <7d400028> 7d4a4b78 7d40012d 40a2fff4

---[ end trace dac0cf4779f83901 ]---


Regards,
Rup
