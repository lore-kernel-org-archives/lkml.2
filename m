Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab1GYOqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:46:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56989 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752102Ab1GYOqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:46:00 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX190Qk40Pbp0pjWeyCkpqJjenG/OdhJUGlnaBRzc7p
	RZmfvC30yr4UJ3
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: kernel 3.0 + bridge : set hello timer failed: Numerical result out of range
Date: Mon, 25 Jul 2011 16:45:56 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0; KDE/4.6.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107251645.56332.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this message with kernel 3.0 under an almost stable Gentoo :

 *   Running postup ...
 * Bringing up interface br0
 *   Creating bridge br0 ...
set hello timer failed: Numerical result out of range
 *   Adding ports to br0
 *     tap0 ... [ ok ]
 *     tap1 ... [ ok ]
 *   192.168.0.254/16 ... [ ok ]
 *   Running postup ...

with these settings :
Code:
brctl_br0="
setfd 0
sethello 30
stp off" 

Kernel 2.6.39.3 doesn't show that. Is this a harmless message ?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
