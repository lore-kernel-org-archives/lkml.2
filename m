Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1HCEnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 00:43:06 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53385 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1HCEnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 00:43:00 -0400
X-Nat-Received: from [202.181.97.72]:52699 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1312346578.12826
Message-Id: <201108030442.p734gwO9050751@www262.sakura.ne.jp>
Subject: git commit id and tarball's filename mapping.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Aug 2011 13:42:58 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 03082011 #5774370, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I regularly test kernels extracted from tarballs rather than from git. I have
problems with estimating range to "git bisect" because I can't know commit id
as of a tarball was archived. I would appreciate if there is a mapping table
that contains commit id and tarball's filename.

0123456789012345678901234567890123456789 linux-3.0.tar.bz2
1234567890123456789012345678901234567890 patch-3.0-git1.bz2
2345678901234567890123456789012345678901 patch-3.0-git2.bz2
3456789012345678901234567890123456789012 patch-3.0-git3.bz2
  (...snipped...)
7890123456789012345678901234567890123456 patch-3.0-git17.bz2
8901234567890123456789012345678901234567 linux-3.1-rc1.tar.bz2
