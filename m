Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2JUPMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 11:12:35 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45830 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab2JUPMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 11:12:33 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [REGRESSION] 3.7-rc2 kernel BUG at kernel/power/snapshot.c:517!
Date: Sun, 21 Oct 2012 17:12:28 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.1; KDE/4.8.4; x86_64; ; )
Cc: lenb@kernel.org, rjw@sisk.pl, linux-acpi@vger.kernel.org, pavel@ucw.cz,
        linux-pm@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201210211712.28571.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error: kernel BUG at kernel/power/snapshot.c:517!

Last known good: 3.6.1
Bad: 3.7-rc2

Steps to reproduce:
1. Boot system with 3.7-rc2 kernel
2. Try suspend to disk (s2ram works OK)

System dies on message:
http://mrutecki.pl/download/kernel/3.7-rc2/swinka/DSCN0280.jpg

lspci:
http://mrutecki.pl/download/kernel/3.7-rc2/swinka/lspci.txt

dmesg:
http://mrutecki.pl/download/kernel/3.7-rc2/swinka/dmesg-3.7-rc2.txt


-- 
Maciej Rutecki
http://www.mrutecki.pl
