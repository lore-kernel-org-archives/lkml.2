Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab1EYSrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:47:09 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:37530 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab1EYSrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:47:07 -0400
Date: Wed, 25 May 2011 20:46:48 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Fabio Erculiani <lxnay@sabayon.org>
Cc: linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbmem: fix race condition between
 register_framebuffer() and fb_open()
Message-ID: <20110525204648.58983270@neptune.home>
In-Reply-To: <BANLkTimxi-LZFzwv=z6RRBCX098hr-ViUg@mail.gmail.com>
References: <1306266871-12464-1-git-send-email-lxnay@sabayon.org>
	<20110524224545.08c53b1d@neptune.home>
	<20110525181917.12cf97b8@neptune.home>
	<BANLkTimxi-LZFzwv=z6RRBCX098hr-ViUg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 Fabio Erculiani <lxnay@sabayon.org> wrote:
> I'm not a fbdev expert. So I leave the real fix to real men ( ;-) ).
> It is causing deadlock during boot, so I would consider it quite critical.
> Users using any fb driver will get into troubles.
> The workaround is to boot with vga=normal.

What is your system doing during boot? I've never seen it here but maybe
my boot sequence is too simple.

Could you tell if it deadlocks before init gets started or afterwards,
which fb drivers (and extra kernel patches if any) are in use.

If you have the complete backtrace of the deadlocked processes it would
help getting a better idea of what is affected and how (and why just the
framebuffer's lock is not causing trouble with earlier kernel versions).

Bruno


> Cheers,
