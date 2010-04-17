Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab0DQOKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 10:10:52 -0400
Received: from ferdi.naasa.net ([87.106.227.76]:35716 "EHLO ferdi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab0DQOKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 10:10:50 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Apr 2010 10:10:50 EDT
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at kernel/power/snapshot.c:522
Date: Sat, 17 Apr 2010 16:01:04 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33.2; KDE/4.4.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201004171601.05025.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get the bug listed in the subject frequently, but not always, 
when I invoke s2disk to suspend to disk with a self-compiled 
kernel 2.6.33.X on my Thinkpad T40. Unfortunately, I cannot 
provide the full error log as text since the error is only 
displayed on the screen. You can get a photo of the full error 
log here:
https://ferdi.naasa.net/url/jplatte/IMG_1931.jpg

If I remember correctly the problem appeared with kernel 2.6.33-
rcX. I first ignored it but now it is getting more and more 
annoying :)

regards,
Jörg
