Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab2D2GB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 02:01:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56324 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751561Ab2D2GB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 02:01:26 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19Nl00/WKZNryBLAE1YXTSbao94sKilFhF/AkQ78b
	9o0d/BR4S9CKGC
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: missing a space in ./init/do_mounts.c in line 509
Date: Sun, 29 Apr 2012 08:01:21 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.4; KDE/4.8.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204290801.21716.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

is there a reason to not have a space after %d ? :

	printk(KERN_INFO "Waiting %dsec before mounting root device...\n",

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
