Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1FNAnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 20:43:11 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54905 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab1FNAnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 20:43:07 -0400
X-Nat-Received: from [202.181.97.72]:60275 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1308012103.5362
Message-Id: <201106140041.p5E0fhAh029531@www262.sakura.ne.jp>
Subject: [3.0-rc3] scripts/depmod.sh: Permission denied
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Jun 2011 09:41:42 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 13062011 #5524395, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-3.0-rc3.tar.bz2 generates
-rwxrwxr-x  1 root root 1231 Jun 14 07:29 linux-3.0-rc3/scripts/depmod.sh
but linux-2.6.39.tar.bz2 + patch-3.0-rc3.bz2 generates
-rw-r--r--  1 root root 1231 Jun 14 09:34 scripts/depmod.sh
which results in

make: execvp: /usr/src/linux-3.0-rc3/scripts/depmod.sh: Permission denied
make: *** [_modinst_post] Error 127

Would you add "chmod +x scripts/depmod.sh" before invoking depmod.sh ?
