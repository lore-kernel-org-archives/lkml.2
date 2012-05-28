Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab2E1JdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:33:06 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34531 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab2E1JdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:33:04 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] tty changes for the locking warnings.
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 28 May 2012 10:48:37 +0100
Message-ID: <20120528094741.3001.29866.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the tty locking warnings. This doesn't include the patches to the
lock markup as I'm not sure which are the final valid ones there.

---

Alan Cox (2):
      tty: fix ldisc lock inversion trace
      pty: Fix lock inversion


 drivers/tty/pty.c       |    2 --
 drivers/tty/tty_ldisc.c |   41 +++++++++++++++++++++++++----------------
 2 files changed, 25 insertions(+), 18 deletions(-)

-- 
