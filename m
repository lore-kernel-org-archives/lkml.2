Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab2I0Pm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:42:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51079 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751420Ab2I0PmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:42:25 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18Eh984itgEV0zGqvYR+UQIpiQE2+bs+xqLBTESrZ
	XFuXzSzrrqR8Sm
Message-ID: <506473D8.10904@gmx.de>
Date: Thu, 27 Sep 2012 17:42:16 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: hot CPU with 3.6.0-rc7+ and intel graphic
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm observing a high CPU usage at my ThinkPad T420 (i5-2540M CPU), w/
integrated intel graphic.

Powertop-2.1 shows that the GPU is always at 100%, although I've defined
these settings :
$> cat /etc/modprobe.d/i915.conf
options i915 i915_enable_rc6=7 lvds_downclock=0

Kernel 3.5.4 works fine, I don't see any differences in dmesg output.



-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
