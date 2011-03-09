Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab1CIJqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:46:47 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43932 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab1CIJqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:46:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=A57Qd32ByVcYWVgPMX65KVX5IeSMnOL4//x7cXroItAnbC0SDNbD8lRWje17tznJ+4
         OXMatL3JtDHiYhDIQ02W7UkMhEYFI8cG2VAZXbpk9mRuKe4aDql7iZFdkI7auCw4XuX4
         p6GCYMDKi1H8MIv9qEkm1jopytbD0e3HNBP04=
From: Wang Lei <f3d27b@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] Fans keep running, first found since v2.6.38-rc7
Date: Wed, 09 Mar 2011 17:46:57 +0800
Message-ID: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, hackers!

I have ever reported some bugs, always got kind help, even though one
thing is not fixed yet, leaving my SBx00 sound card no voice.

Recently, i encounter another problem, after startup all fans keep
running. I guess it's a bug. I first saw this at v2.6.38-rc7. It still
exists at v2.6.38-rc8. The version I'm running now, v2.6.38-rc6+, is OK.

I cat /sys/class/thermal/thermal_zone0/trip_point_*_temp at the latest
v2.6.38-rc8, get this output:

[~]$ cat /sys/class/thermal/thermal_zone0/trip_point_*_temp
105000
15900
15900
15900
15900
15900
[~]$ 

This is the output at v2.6.38-rc6+:

[~]$ cat /sys/class/thermal/thermal_zone0/trip_point_*_temp
105000
95000
75000
65000
55000
40000
[~]$

Any help is appreciated.

Cheers,
Lei
