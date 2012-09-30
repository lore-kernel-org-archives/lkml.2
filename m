Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab2I3MyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 08:54:11 -0400
Received: from smtp.getmail.no ([84.208.15.66]:52580 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2I3MyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 08:54:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Date: Sun, 30 Sep 2012 14:54:07 +0200
Subject: re: Linux 3.5-rc7
To: linux-kernel@vger.kernel.org
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wlf8shgd6426ze@localhost.localdomain>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiled 3.6-rc7, with a hz timer of 3956 for a "natural" psychovisual  
profile jitter level in OpenGL, and a shaved config for minimal jitter.

Also changed the 10ms filter in fair.c to 1. And I suggest the whole  
filter to be removed. https://lkml.org/lkml/2012/9/30/78

There is very few clicks with ALSA + onboard soundcard at 0.3ms lantecy  
now, without RT-threads.

Meaning os-jitter is near optimal for audio/video. I think few care once  
it is below 0.2ms.

Ofcourse one always wants lower, but at that point, things feel like  
hardware, and becomes unnoticable to the user.

Peace Be With You.
