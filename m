Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2HTT3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:29:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65317 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab2HTT3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:29:05 -0400
Date: Mon, 20 Aug 2012 12:29:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: [GIT PATCH] One more driver core fix for 3.6-rc3
Message-ID: <20120820192901.GA15744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7b7e995d69199b555181ac057c47b017c510a129:

  extcon: extcon_gpio: Replace gpio_request_one by devm_gpio_request_one (2012-08-16 10:29:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.6-rc3

for you to fetch changes up to ebdc82899ec5ed35af1c79ed6a4eeda69dad9b90:

  dyndbg: fix for SOH in logging messages (2012-08-18 23:40:13 -0700)

----------------------------------------------------------------
dmesg fix for 3.6-rc3

Here is one fix for the dmesg line corruption problem that the previous
set of patches caused.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Markus Trippelsdorf (1):
      dyndbg: fix for SOH in logging messages

 drivers/base/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
