Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab2JXKCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:02:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54794 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab2JXKCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:02:16 -0400
Date: Wed, 24 Oct 2012 12:02:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Robert Love <rlove@rlove.org>
Subject: [Q] CONFIG_INOTIFY_USER doesn't get enabled upon defconfig
Message-ID: <Pine.LNX.4.64.1210241057590.31768@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:A9KuGw82Xb9SIxXid6gOzYIFHf4fVUwNTslsdpAeXC8
 025sSC2mozIzHQ56nd5xQlap9LwnuZzctmKwNDoM+d0oAthTIx
 T8FM1bh3i421jMe9/yKDZnxp/JjUS1QxK0q3HC+DkqMiAU14A6
 YinwD0Ylbm2SHhfNHbnG9d5mGYMsiKrgEXdLfHFv4/MCoqBel4
 ftdzJc/Lw8Qm6VK/ucM5Dep9LXSCyqZysKd95WK34nLUZQIx0F
 H+wFcNDxFMHZmX7x0QTQ9odIT6i2COX1ba/qPN8+VjScq9ntVI
 qAeHH8amdi8G1nwlAA5WSmzq4iEejWlerNADx1PL389hdC44bn
 Jdb0Ol4idBWqnU0nhB5Dvt2Lx5tRBuHDy/l+RaMgjKIaOrA76R
 y/HAHgdpSlCRw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

CONFIG_INOTIFY_USER is marked default "y" in fs/notify/inotify/Kconfig, 
so, I would expect it to be enabled by any make *_defconfig. However, for 
some reason, this doesn't happen (e.g. with mackerel_defconfig), which 
leads to non-functional udev, among others. Any idea why this could be 
happening?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
