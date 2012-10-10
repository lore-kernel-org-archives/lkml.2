Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2JJQdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:33:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53870 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751535Ab2JJQdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:33:53 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19pq8oLWjlpO3fr+T5XILrqalo7ChURxuexowrlrO
	3iXagouX44pIYe
Message-ID: <5075A36D.2000301@gmx.de>
Date: Wed, 10 Oct 2012 18:33:49 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: intel-gfx@lists.freedesktop.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: RC6 for an Intel GU doesn't always work
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes - after a reboot or after wakeup from s2disk I'm observed at
my ThinkPad T420 (i5-2540M CPU) w/ integrated intel graphic (i915
module) since 3.6-rc(5?), that the temperature is above 80°C (usually it
is around/lower than 50 °C). Powertop-2.1 shows, that the all 4 CPU
cores are mostly idle, but the GPU is running at 100%. It looks for me
that the power saving mode RC6 isn't active.

After 1-2 s2ram's however the issue went away.

I'm observing the issue both under my Gentoo Linux and under a RH system
(kernel 3.6.1 each).

It is hard to bisect b/c not reliable.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
