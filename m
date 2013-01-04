Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3ADMbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 07:31:05 -0500
Received: from 5350504D.static.ziggozakelijk.nl ([83.80.80.77]:48387 "EHLO
	ns2.tasking.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab3ADMbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 07:31:04 -0500
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jan 2013 07:31:03 EST
To: linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2013 13:21:14 +0100
From: Kees Bakker <spam@tasking.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
Subject: drm/nouveau E[     DRM] fail ttm_validate
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
NNTP-Posting-Host: 172.17.1.96
Message-ID: <65b9.50e6c93a.b1791@altium.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Right after I upgraded to Ubuntu quantal I started seeing these
messages:
Jan  4 12:18:12 koli kernel: [ 3705.970720] nouveau E[     DRM] fail ttm_validate
Jan  4 12:18:12 koli kernel: [ 3705.970726] nouveau E[     DRM] validate vram_list
Jan  4 12:18:12 koli kernel: [ 3705.970760] nouveau E[     DRM] validate: -12

A few times I had corrupted graphics, and I had to stop X. Restarting didn't
help and I had to reboot.

I'm running my own 3.7.1 kernel, so I also installed the 3.7.0 development kernel
from Ubuntu (3.7.0-7). And that kernel shows these messages too.

With the Ubuntu kernel the graphics corruption is milder. I can continue to work. Sometimes
I get a burst of the messages, but I have no clue how it is triggered.

Now the strange thing is that I was running my 3.7.1 kernel on Ubuntu precise
and I have never seen these messages before. What could be the case is that
xorg is doing something new and that is causing the errors.

xserver-xorg-video-nouveau
   precise 1:1.0.2-0ubuntu3
   quantal 1:0.0.16+git20111201+b5534a1-1build2

Some more details
/var/log/syslog:Jan  4 11:16:42 koli kernel: [    0.000000] Linux version 3.7.0-7-generic (root@koli) (gcc version 4.7.2 (Ubuntu/Lin
/var/log/syslog:Jan  4 11:16:44 koli kernel: [   18.081288] [drm] Initialized drm 1.1.0 20060810
/var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.615246] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x04b300b1
/var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.615251] nouveau  [  DEVICE][0000:01:00.0] Chipset: G73 (NV4B)
/var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.615254] nouveau  [  DEVICE][0000:01:00.0] Family : NV40
/var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.616802] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
/var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.655315] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
/var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.655320] nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
/var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.655505] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
/var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.655509] nouveau  [   VBIOS][0000:01:00.0] version 05.73.22.67
/var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.660805] nouveau  [     PFB][0000:01:00.0] RAM type: DDR2
/var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.660811] nouveau  [     PFB][0000:01:00.0] RAM size: 256 MiB

-- 
Kees Bakker

