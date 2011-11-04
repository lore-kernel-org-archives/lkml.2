Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab1KDGQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 02:16:36 -0400
Received: from tur.go2.pl ([193.17.41.50]:46259 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab1KDGQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 02:16:36 -0400
Subject: =?UTF-8?Q?Bug_rtl8168?=
From: =?UTF-8?Q?Krzysztof_Ksi=C4=85=C5=BCek?= <bond009@o2.pl>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Message-ID: <7a1fedde.71754b01.4eb382e1.1200a@o2.pl>
Date: Fri, 04 Nov 2011 07:14:57 +0100
X-Originator: 83.5.78.40
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear support team,
In the kernel 3.0.8 and 3.1 there is some bug with ethernet controller RTL8111/8168B PCI,

my ls pci output:
07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)

bug in syslog:
r8169 0000:07:00.0: eth0: unable to load firmware patch rtl_nic/rtl8168e-3.fw (-2)

Best regards
Krzysztof
