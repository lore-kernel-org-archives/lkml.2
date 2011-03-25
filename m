Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1CYVdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:33:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47964 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755150Ab1CYVdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:33:23 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19JvZZKNI1JgYxmGZlSWIQa2G3mYB7dQjW3JsZFQT
	T0Kf6LcY75oVO8
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: xterm keyboard response is slow with recent kernel (regression)
Date: Fri, 25 Mar 2011 22:33:16 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38.1; KDE/4.6.1; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103252233.17424.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I start a straight X11 session with ctwm (or twm, lwm etc ...) with 
"startx" and type in a command into a xterm, since kernel 2.6.37.4 (and 
2.6.38.1 too) it needs a loooong time until the appropriate pressed key 
appears in the xterm. If I press ENTER however both the command and the output 
appears immediately.
Sometimes the whole command is printed only after I pressed the RETURN key.

Furthermore it needs a much longer time than usual after "startx" until the 
window manager draws the border (incl. the scroll bar) to the terminal, the 
process X is running at 50% (100% of a core) within that time frame.

I've a Lenovo ThinkPad T400 with integrated intel graphic (GM45), xorg-server 
version is 1.9.5

With kernel 2.6.36.4 however there's no problem AFAICS.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
