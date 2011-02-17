Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab1BQQJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:09:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62020 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab1BQQJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:09:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=iEl18rgWwyyoGVo1RUyZQWX7q3FItGg0syPD1zLM22C+Se8Ua512koQ1J/J5INPDsS
         4km08Sj+lA8h/R+UhtsHzUM3wP9BMUI4zs7dqtyj6C1n7LKvfV6pV5xIufTbpyXPHzZU
         YNn7mwOfadi2lb4Quprskd52sIR2cN4hycacU=
Message-ID: <4D5D4846.60205@gmail.com>
Date: Thu, 17 Feb 2011 19:09:42 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: some warnings on headers
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, while were testing p4 patch in -tip/master I've found the following warnings

linux-2.6.tip/usr/include/drm/drm_mode.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-2.6.tip/usr/include/drm/i915_drm.h:120: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-2.6.tip/usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-2.6.tip/usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-2.6.tip/usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-2.6.tip/usr/include/linux/kernel.h:58: userspace cannot reference function or variable defined in the kernel
linux-2.6.tip/usr/include/linux/quota.h:175: userspace cannot reference function or variable defined in the kernel
linux-2.6.tip/usr/include/linux/sdla.h:116: userspace cannot reference function or variable defined in the kernel
linux-2.6.tip/usr/include/linux/soundcard.h:1054: userspace cannot reference function or variable defined in the kernel
linux-2.6.tip/usr/include/scsi/scsi_netlink.h:108: found __[us]{8,16,32,64} type without #include <linux/types.h>

I've left .config in office but could pick up it and reveal tomorrow (it's p4 x86-32). I don't think it's anyhow
serious but if some brave sould would like to figure out what might need be fixed -- I desided to post a mail ;)

-- 
     Cyrill
