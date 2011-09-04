Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1IDWPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 18:15:18 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:36431 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab1IDWPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 18:15:14 -0400
X-Greylist: delayed 1279 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Sep 2011 18:15:14 EDT
From: Hans A Eide <h.a.eide@usit.uio.no>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: IRQ balancing on Sandy Bridge?
Date: Sun, 4 Sep 2011 23:53:53 +0200
Message-Id: <7EEBACB7-6D3C-41CA-B685-E48D5AD0FAB6@usit.uio.no>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1244.3)
X-Mailer: Apple Mail (2.1244.3)
X-UiO-Ratelimit-Test: rcpts/h 17 msgs/h 9 sum rcpts/h 17 sum msgs/h 9 total rcpts 18423 max rcpts/h 35 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, TVD_RCVD_IP=0.001,UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: FE64A74FE7233001C099C164A326CFF430777F51
X-UiO-SPAM-Test: remote_host: 84.49.236.242 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 9 total 3956 max/h 12 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, just a quick question I haven't been able to google:

/proc/interrupts on my SB i5-2500 desktop running kernels up to 3.1.0-rc4+
tells me there is no IRQ balancing going on, like f.ex. on my Nehalem i5-660.
Same config (basically std. Debian wheezy conf.)

Shouldn't there be IRQ balancing for SB or did I miss something?

Thanks,


Hans


--
Hans A Eide, PhD.
Research Computing Services, USIT
University of Oslo, Norway



