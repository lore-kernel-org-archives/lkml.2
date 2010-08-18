Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0HRSqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 14:46:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37913 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab0HRSqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 14:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=naD5dIt2HZIquEzevQCPIRronYV5iCkTGjX9YUcc+7z3FDpYsDBnva9lI14Zr20kjI
         eebnsGMQJca0STaJqlekgROgOggFoAHjrS2XgA4MMV0KNAtq233c2MRzvvqe+Y/YWd0z
         2h2f8e2BBRZG2Md+ZKpClFd+FGq8lKAJzckYA=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@linux.ie
Subject: [REGRESSION] [2.6.36-rc1] [DRM INTEL] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 36, available = 28.
Date: Wed, 18 Aug 2010 20:46:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008182046.37732.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known good: 2.6.35
Failing kernel: 2.6.36-rc1

During boot kernel display this message:
[    0.831906] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, 
expect flickering: entries required = 36, available = 28.
[    0.895058] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, 
expect flickering: entries required = 36, available = 28.
[    0.895066] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, 
expect flickering: entries required = 36, available = 28.
[    0.895287] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, 
expect flickering: entries required = 36, available = 28.
[    0.916426] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, 
expect flickering: entries required = 36, available = 28.


Systems seems work OK, but in 2.6.35 I don't have this message. On another 
system with 2.6.36-rc1 kernel I have the same message.

lspci:
http://unixy.pl/maciek/download/kernel/2.6.36-rc1/zlom/lspci.txt
.config:
http://unixy.pl/maciek/download/kernel/2.6.36-rc1/zlom/config-2.6.36-rc1
dmesg:
http://unixy.pl/maciek/download/kernel/2.6.36-rc1/zlom/dmesg-2.6.36-rc1.txt

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
