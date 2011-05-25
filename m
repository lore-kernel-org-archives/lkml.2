Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1EYSRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:17:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58188 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab1EYSRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:17:09 -0400
MIME-Version: 1.0
In-Reply-To: <20110525181917.12cf97b8@neptune.home>
References: <1306266871-12464-1-git-send-email-lxnay@sabayon.org>
	<20110524224545.08c53b1d@neptune.home>
	<20110525181917.12cf97b8@neptune.home>
Date: Wed, 25 May 2011 20:17:08 +0200
X-Google-Sender-Auth: PGMetK6cqJY9MO6TsnT8z-MkfgE
Message-ID: <BANLkTimxi-LZFzwv=z6RRBCX098hr-ViUg@mail.gmail.com>
Subject: Re: [PATCH] fbmem: fix race condition between register_framebuffer()
 and fb_open()
From: Fabio Erculiani <lxnay@sabayon.org>
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not a fbdev expert. So I leave the real fix to real men ( ;-) ).
It is causing deadlock during boot, so I would consider it quite critical.
Users using any fb driver will get into troubles.
The workaround is to boot with vga=normal.

Cheers,
-- 
Fabio Erculiani
