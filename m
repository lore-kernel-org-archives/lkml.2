Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab2BWJwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 04:52:49 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39592 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2BWJwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 04:52:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of christian.gmeiner@gmail.com designates 10.220.116.7 as permitted sender) smtp.mail=christian.gmeiner@gmail.com; dkim=pass header.i=christian.gmeiner@gmail.com
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Thu, 23 Feb 2012 10:52:27 +0100
Message-ID: <CAH9NwWcbYRq9z_i8BcuQoK05+=ugyLqymHh9H6y963xWNnp2EA@mail.gmail.com>
Subject: Change MAC address permanently
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have found out that ioctl SIOCSIFHWADDR could be used to change the
current MAC address
of an Ethernet device. But the big problem is that after an reboot the
change is gone. Is there
an other way of changing the MAC address permanently?

I am asking, as I am working in a company which does produce devices
which are using Intel
based NICs and where Linux is used as OS. At the moment we need to
boot vxworks to change
the MAC address and could the "install" Linux on the device. The
biggest problem here is that
for vxworks we need an other BIOS as for Linux.

Thanks for any hints
--
Christian Gmeiner, MSc
