Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab1IIOX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:23:56 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:42205 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200Ab1IIOXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:23:55 -0400
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-mm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: found __[us]{8,16,32,64} type without #include <linux/types.h>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/24.0.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAgMAAABinRfyAAAACVBMVEX///8ZGXBQKKnCrDQ3
 AAAAJElEQVQImWNgQAAXzwQg4SKASgAlXIEEiwsSIYBEcLaAtMEAADJnB+kKcKioAAAAAElFTkSu
 QmCC
Copyright: Copyright 2011 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Fri, 09 Sep 2011 10:22:39 -0400
Message-ID: <m3vct1u75k.fsf@jhcloos.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All noticed while compiling 3.1-r5:

linux/usr/include/drm/drm_mode.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux/usr/include/drm/i915_drm.h:120: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux/usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux/usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux/usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>

linux/usr/include/scsi/scsi_netlink.h:108: found __[us]{8,16,32,64} type without #include <linux/types.h>

linux/usr/include/linux/mmc/ioctl.h:10: found __[us]{8,16,32,64} type without #include <linux/types.h>


-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
