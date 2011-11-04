Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab1KDSXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 14:23:31 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:48045 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933092Ab1KDSX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 14:23:29 -0400
Message-ID: <4EB42D69.7030503@xenotime.net>
Date: Fri, 04 Nov 2011 11:22:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Wang Sheng-Hui <shhuiw@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/8] Documentation: drop as block elevator reference in switching-sched.txt
References: <4EB423D8.9030102@xenotime.net>
In-Reply-To: <4EB423D8.9030102@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Sheng-Hui <shhuiw@gmail.com>

Remove 'as' for as is no longer supported.



The patch is against 3.1-rc3.



as is no longer supported and we can not use 'elevator=as' any

more.



Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Cc: Jens Axboe <axboe@kernel.dk>

---

 Documentation/block/switching-sched.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


--- lnx1104.orig/Documentation/block/switching-sched.txt
+++ lnx1104/Documentation/block/switching-sched.txt
@@ -1,6 +1,6 @@
 To choose IO schedulers at boot time, use the argument 'elevator=deadline'.
-'noop', 'as' and 'cfq' (the default) are also available. IO schedulers are
-assigned globally at boot time only presently.
+'noop' and 'cfq' (the default) are also available. IO schedulers are assigned
+globally at boot time only presently.
 
 Each io queue has a set of io scheduler tunables associated with it. These
 tunables control how the io scheduler works. You can find these entries
