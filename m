Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab2HQROU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:14:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63837 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab2HQROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:14:08 -0400
Date: Fri, 17 Aug 2012 10:13:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: [GIT PATCH] Driver core fixes for 3.6-rc3
Message-ID: <20120817171354.GA14046@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.6-rc3

for you to fetch changes up to 7b7e995d69199b555181ac057c47b017c510a129:

  extcon: extcon_gpio: Replace gpio_request_one by devm_gpio_request_one (2012-08-16 10:29:08 -0700)

----------------------------------------------------------------
Driver core fixes for 3.6-rc3

Here are two tiny patches, one fixing a dynamic debug problem that the printk
rework turned up, and the other one fixing an extcon problem that people
reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Axel Lin (1):
      extcon: extcon_gpio: Replace gpio_request_one by devm_gpio_request_one

Jim Cromie (1):
      drivers-core: make structured logging play nice with dynamic-debug

 drivers/base/core.c          | 9 +++++++--
 drivers/extcon/extcon_gpio.c | 3 ++-
 2 files changed, 9 insertions(+), 3 deletions(-)
