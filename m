Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2IOJac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 05:30:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53504 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751530Ab2IOJab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 05:30:31 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/ap1962OXaU3VPAzcuuVZ+7oMUKo2F5+rTbNHLsX
	NqCd8Zo49Wm15i
Message-ID: <50544AB2.302@gmx.de>
Date: Sat, 15 Sep 2012 11:30:26 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: w/ current kernel (3.5.3) I need 2 attempts for s2disk in a row
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WIth a ThinkPad T420 latest BIOS and current kernel, ( GB RAM and 10 GB swap space Ioften need 2 attempts in a row to s2disk.
The first fails while the second (immediately after it) works :

22012-09-15T05:17:54.114+02:00 n22 kernel: PM: Need to copy 719868 pages
2012-09-15T05:17:54.114+02:00 n22 kernel: PM: Normal pages needed: 146128 + 1024, available pages: 81456
2012-09-15T05:17:54.114+02:00 n22 kernel: PM: Not enough free memory
2012-09-15T05:17:54.114+02:00 n22 kernel: PM: Error -12 creating hibernation image


...

2012-09-15T11:02:43.192+02:00 n22 kernel: PM: Creating hibernation image:
2012-09-15T11:02:43.192+02:00 n22 kernel: PM: Need to copy 384852 pages
2012-09-15T11:02:43.202+02:00 n22 kernel: PM: Normal pages needed: 65642 + 1024, available pages: 161930
2012-09-15T11:02:43.202+02:00 n22 kernel: PM: Restoring platform NVS memory


/me wonders whether it is a known issue or special to my system.


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
