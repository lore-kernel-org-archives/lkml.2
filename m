Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474Ab0GWP3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:29:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:58796 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758751Ab0GWP3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:29:30 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19FeDsrF/9FRAggxgANDaOiXUWg7cqvi+A6o4dW52
	EDycBzwBMTktCI
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: minor viafb updates
Date: Fri, 23 Jul 2010 15:39:15 +0000
Message-Id: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All patches can also be found at
	git://github.com/schandinat/linux-2.6.git viafb-s1v1

Some tests were performed on CLE266, VX800 and VX855.

Further testing and/or comments appreciated.


Thanks,

Florian Tobias Schandinat


Florian Tobias Schandinat (11):
      MAINTAINERS: update viafb entry
      viafb: remove duplicated scaling code
      viafb: improve lcd code readability
      viafb: add lcd scaling support for some IGPs
      viafb: fix PCI table
      viafb: simplify lcd size "detection"
      viafb: PLL value cleanup
      viafb: update fix before calculating depth
      viafb: remove ioctls which break the framebuffer interface
      viafb: probe cleanups
      viafb: fix accel_flags check_var bug

