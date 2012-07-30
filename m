Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab2G3FtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 01:49:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46986 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2G3FtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 01:49:15 -0400
Date: Sun, 29 Jul 2012 22:49:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/2] Report wake_events for some button presses.
Message-ID: <20120730054909.GA5830@core.coreip.homeip.net>
References: <20120730010746.22579.52841.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120730010746.22579.52841.stgit@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 11:09:01AM +1000, NeilBrown wrote:
> To avoid racing with suspend, we need to report wakeup events to the
> pm subsystem when they happen.
> These two patches do this for gpio_keys and twl4030-pwrbutton.
> 
> ---
> 
> NeilBrown (2):
>       Input: twl4030-pwrbutton: report a wakeup_event on button press.
>       Input: gpio_keys: report a wakeup_event for a button press on a wake_up button.
> 

Applied both, thanks Neil.

-- 
Dmitry
