Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab2GYIUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:20:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35724 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab2GYIUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:20:51 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [REGRESSION] [KMS] [INTEL] Wrong resolution in console and XWindow
Date: Wed, 25 Jul 2012 10:20:47 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-rc3; KDE/4.8.4; x86_64; ; )
Cc: dri-devel@lists.freedesktop.org, airlied@linux.ie
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207251020.47637.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known good: 3.4.4
First bad: 3.5.0

When booting 3.5.0 resolution (in console, and after in KDE) is set to 
1024x768 (60Hz). In 3.4.4 was correct: 1440x900 (60Hz).

Dmesg from 3.5.0:
http://mrutecki.pl/download/kernel/3.5/swinka/dmesg-3.5.0.txt

Dmesg from 3.4.4:
http://mrutecki.pl/download/kernel/3.5/swinka/dmesg-3.4.4.txt

Config 3.5.0:
http://mrutecki.pl/download/kernel/3.5/swinka/config-3.5.0

lspci:
http://mrutecki.pl/download/kernel/3.5/swinka/lspci.txt

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
