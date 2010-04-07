Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0DGWkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 18:40:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab0DGWkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 18:40:46 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.34-rc3++ looses PS2 keyboard eventually in xterms
Date: Thu, 8 Apr 2010 00:40:41 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004080040.41373.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX19yhoimDptBx+KVc5AfQYRkjNvbloS/i1sxZi+
 KHXqfm+2BLZhoxJNRBKTyTDc697AC/FDwr+1KSdNwRgf692hR+
 oBoB36XIaLYVvjnqKy++ukO4+7gAKKy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after switching to 2.6.34-rc3 with follow ups added up to 5e11611a (e.g. 
including the tty fix), I still suffer from "loosing" my PS2 keyboard 
eventually during work in xterms (which I do use a lot). Everything else, 
ssh'ing from remotes, mouse operations, even mouse clicks into xterms is 
still functional, e.g. I'm able to quit htop by clicking on F10. Just every 
direct keyboard input is lost, without a trace in syslog, as well as 
Alt-SysReq sequences. echo r > /proc/sysrq-trigger doesn't show any effects 
either. AFAICT, it doesn't happen with older kernels (2.6.33.2/2.6.27.y). 

OS/Hardware:
openSUSE 11.1/i586, KDE3, ASUS P7P55-WS, Xeon X3460, 4 GB.

Any hint on how to debug such an issue is much appreciated.

Thanks,
Pete
