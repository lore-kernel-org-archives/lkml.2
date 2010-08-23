Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0HWNer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:34:47 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34051 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab0HWNen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:34:43 -0400
Message-ID: <4C7278F0.1020406@kernel.dk>
Date: Mon, 23 Aug 2010 15:34:40 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] 1 small driver update
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As this really doesn't belong in the block parts, I setup a one-off
branch to pass this along. It has been acked by the maintainer/author
of the driver and he doesn't wish to submit it himself.

  git://git.kernel.dk/linux-2.6-block.git misc

Jens Axboe (1):
      ipheth: add support for iPhone 4

 drivers/net/usb/ipheth.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


-- 
Jens Axboe

