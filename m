Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab2G3BJm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 21:09:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab2G3BJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 21:09:40 -0400
From: NeilBrown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Mon, 30 Jul 2012 11:09:01 +1000
Subject: [PATCH 0/2] Report wake_events for some button presses.
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Message-ID: <20120730010746.22579.52841.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid racing with suspend, we need to report wakeup events to the
pm subsystem when they happen.
These two patches do this for gpio_keys and twl4030-pwrbutton.

---

NeilBrown (2):
      Input: twl4030-pwrbutton: report a wakeup_event on button press.
      Input: gpio_keys: report a wakeup_event for a button press on a wake_up button.


 drivers/input/keyboard/gpio_keys.c     |    7 +++++++
 drivers/input/misc/twl4030-pwrbutton.c |    1 +
 2 files changed, 8 insertions(+)

-- 
Signature

