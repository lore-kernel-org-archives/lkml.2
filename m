Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1BWQ74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 11:59:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56647 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1BWQ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:59:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KcExaf8yn3g8C7Gp5QYMi6LhE+8RbZZQYMkIvzTxpzRIpkXFsaVVEOEEWA5ZSQi1L9
         GsQ3abUNc2Tr5/Csw/piJlEKgeGmbCCZM+92Hc0CKMXWmFqUx7QlCDBoNpQorMczYmrm
         6pEZhq0GxdUYAFD8P0bQTV32xj7YZSEDz+pMo=
Date: Wed, 23 Feb 2011 08:59:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.38-rc6
Message-ID: <20110223165947.GA22962@core.coreip.homeip.net>
References: <20110107065448.GC29038@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107065448.GC29038@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a fix for
recently reported boot time regression (longish serio works badly
interacting with flush_scheduled_work() used by tty layer), update
documenting new(ish) 0x0c query in Synaptics protocol and final polishes
for the tegra keyboard driver (which is new in this release).

Thanks!


Changelog:
---------

Dmitry Torokhov (2):
      Input: synaptics - document 0x0c query
      Input: serio/gameport - use 'long' system workqueue

Rakesh Iyer (1):
      Input: tegra-kbc - add function keymap


Diffstat:
--------

 arch/arm/mach-tegra/include/mach/kbc.h |    1 +
 drivers/input/gameport/gameport.c      |    2 +-
 drivers/input/keyboard/tegra-kbc.c     |   62 ++++++++++++++++++++++++++++++--
 drivers/input/mouse/synaptics.h        |   23 ++++++++++++
 drivers/input/serio/serio.c            |    2 +-
 5 files changed, 85 insertions(+), 5 deletions(-)

-- 
Dmitry
