Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab2KYJD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 04:03:29 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:53891 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2KYJDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 04:03:25 -0500
X-Nat-Received: from [202.181.97.72]:51396 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1353834167.27203
To: dhowells@redhat.com, sam@ravnborg.org
Cc: arnd@arndb.de, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        davej@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [3.7-rc6] Build failure with scripts/Makefile.headersinst
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201211192202.IBE48444.VHFLtOSOQFOMJF@I-love.SAKURA.ne.jp>
	<201211172227.BHB30739.OVOMFtFLHOFSQJ@I-love.SAKURA.ne.jp>
	<24020.1353323415@warthog.procyon.org.uk>
	<26846.1353334165@warthog.procyon.org.uk>
	<201211202322.AED21884.FJtLHOFSOOQVMF@I-love.SAKURA.ne.jp>
In-Reply-To: <201211202322.AED21884.FJtLHOFSOOQVMF@I-love.SAKURA.ne.jp>
Message-Id: <201211251802.BEJ43247.SHFOJOFVQLFtOM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 25 Nov 2012 18:02:37 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 25112012 #8516623, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Linux 3.6 builds fine. I can't use "git bisect" until Linux 3.7-rc6 but
> possibly caused by either commit 10b63956 "UAPI: Plumb the UAPI Kbuilds into
> the user header installation and checking" or commit 40f1d4c2 "UAPI: Remove the
> objhdr-y export list".

Bisected to commit 10b63956 "UAPI: Plumb the UAPI Kbuilds into the user header
installation and checking".
