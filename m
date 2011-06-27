Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1F0KWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 06:22:30 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:57823 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab1F0KUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 06:20:53 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Subject: coretemp: Support for Intel Atom E6XX CPU (TunnelCreek)?
Date: Mon, 27 Jun 2011 12:20:51 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106271220.51953.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a patch (for v2.6.39) which adds support for Intel Atom E6XX 
(TunnelCreek) to coretemp. It's merely only adding x86_model 0x26.
But there are models (e.g. E660 and E660T) with different TjMax, namely 90 
degrees C and 110 degrees C. But these different model can't be detected by 
reading from hardware.
IMO there should be some support to adjust the temperature from userspace. 
Reading Documentation/hwmon/sysfs-interface only temp1_offset seems to be 
useable. But I think it is somewhat misleading (especially on multicores), 
because there must only be one offset.
What do you think about this?

Regards,
Alexander
