Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1JYWV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 18:21:58 -0400
Received: from mail5.aviatnet.com ([192.147.115.32]:30271 "EHLO
	mail5.aviatnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab1JYWV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 18:21:57 -0400
Subject: Zarlink ZL30143 DPLL Driver
From: Austin Boyle <Austin.Boyle@aviatnet.com>
To: <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Oct 2011 11:21:51 +1300
Message-ID: <1319581311.3172.48.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.1.193]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have written a driver for the Zarlink ZL30143 DPLL. It would typically
be used in an embedded system as part of Sync-E support. The device is
accessed via an I2C interface. In general the driver just exports
register read/write functions, but I have also added some ioctl's to
get/set various settings that require multiple register writes (e.g.
selecting references, setting up priorities) and interrupt support.

I can't find any similar drivers, but I can see that most of the
configuration for this device could just be done using i2c-tools in user
space. I would imagine there are too many generic I2C devices to include
a separate driver for each of them in the kernel. Is there any point
submitting a patch for this? In what system would this kind of device
belong?

Kind regards,
Austin

....................................................................

Austin Boyle
Software Engineer
AVIAT NETWORKS
Direct: + 64 577 8711
Mobile: + 64 27 488 0221
Email:  Austin.Boyle@aviatnet.com
Web:    www.aviatnetworks.com 
Skype:  boyle.austin

