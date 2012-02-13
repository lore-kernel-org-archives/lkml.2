Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab2BMU6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:58:18 -0500
Received: from blackhole.sdinet.de ([176.9.52.58]:52742 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab2BMU6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:58:16 -0500
Date: Mon, 13 Feb 2012 21:58:08 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: stable@vger.kernel.org
cc: Linux-Kernel-Mailinglist <linux-kernel@vger.kernel.org>
Subject: 2.6.32.55+ printk_ratelimit()
Message-ID: <alpine.DEB.2.02.1202132148450.32459@aurora.sdinet.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

catching up with the stable kernel 2.6.32 I saw that 2.6.32.55 included 
8a64f33 "kernel.h: add printk_ratelimited and pr_<level>_rl"

Could it be that 2.6.32.x now also should get upstream 
d8521fcc5e0ad3e79bbc4231bb20a6cdc2b50164 "printk_ratelimited(): fix 
uninitialized spinlock" ?

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
