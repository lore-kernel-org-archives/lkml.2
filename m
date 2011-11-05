Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab1KEO2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 10:28:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37175 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1KEO2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 10:28:20 -0400
Message-ID: <4EB54800.2010408@gmail.com>
Date: Sat, 05 Nov 2011 15:28:16 +0100
From: Carla Sella <carla.sella@gmail.com>
Reply-To: carla.sella@gmail.com
Organization: Carla Sella
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG: re-enabling wireless network on network manager does not work
 properly
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm reporting upstream a bug I already have reported in launchpad for
Ubuntu.
If you disable wireless networking on network manager and then re-enable
it, wireless networks are not displayed anymore.
To get them displayed again you have to check enable wireless, uncheck
enable networking and re-check enable networking, and then you will see
the wireless networks again.

This is the bug I opened on launchpad with all the details:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/876822

-- 
Carla Sella
email: carla.sella@gmail.com
https://launchpad.net/~carla-sella

