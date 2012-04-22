Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab2DVQtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 12:49:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37013 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751340Ab2DVQtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 12:49:39 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18HHMxgacAHcC+Ga5DrqBJ5xhBNVk4ikt9ZVCUtNG
	so46BOjqFtUIuG
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: hibernate a system booted from external USB drive - is it posible ?
Date: Sun, 22 Apr 2012 18:49:30 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.2; KDE/4.8.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204221849.31198.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder, whether it is expect to work with current stable kernel 3.3.2 or 
not. Seems not to work here (s2ram works fine).
Hibernate however writes data to the swap partition, but during wakeup I get :

kernel: PM: Hibernation image partition 8:6 present
kernel: PM: Looking for hibernation image.
kernel: PM: Image not found (code -22)
kernel: PM: Hibernation image not present or could not be loaded. 

and the system continues with normal boot. In addition there's a message from 
swapon, that a suspend data signature was found and that is is overwritten 
with the swap signature.

:-(

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
