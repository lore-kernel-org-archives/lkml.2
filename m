Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab0HTF3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 01:29:03 -0400
Received: from leo.clearchain.com ([199.73.29.74]:33997 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0HTF3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 01:29:00 -0400
From: Peter Hutterer <peter.hutterer@who-t.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pinglinux@gmail.com, rydberg@euromail.se
Subject: [PATCH 0/3] touch tablet support for the w8001 serial driver
Date: Fri, 20 Aug 2010 14:55:32 +1000
Message-Id: <1282280135-15942-1-git-send-email-peter.hutterer@who-t.net>
X-Mailer: git-send-email 1.7.2.1
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Fri, 20 Aug 2010 14:24:59 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These patches add support for newer tablets to the wacom w8001 serial
driver. The first patch simply adds the support for the Pen/Eraser tool and
the stylus button.

The second patch detects touch-capable tablets and discard their packets.
Touch packets are interleaved with pen packets and their length depends on
the sensor model. Detect these packets and discard them silently.

The third patch adds MT slot support for two-finger touch devices.

Patches tested on a 2 finger touch device but i've had positive confirmation
that 1 finger devices don't break.

Cheers,
  Peter
