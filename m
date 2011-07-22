Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1GVIl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:41:28 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49377 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab1GVIl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:41:26 -0400
X-Nat-Received: from [202.181.97.72]:55972 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1311324076.3442
Message-Id: <201107220841.p6M8fGq0079572@www262.sakura.ne.jp>
Subject: Re: linux-next: manual merge of the security-testing tree with the vfs tree
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: jmorris@namei.org, viro@zeniv.linux.org.uk
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 22 Jul 2011 17:41:15 +0900
References: <20110718153917.4aa9a18b80c0933cee4e638b@canb.auug.org.au>
In-Reply-To: <20110718153917.4aa9a18b80c0933cee4e638b@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 22072011 #5674753, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Today's linux-next merge of the security-testing tree got a conflict in
> security/tomoyo/realpath.c between commit 6ef0dd885ce8 ("get rid of
> pointless checks for dentry->sb == NULL") from the vfs tree and commit
> 5625f2e32663 ("TOMOYO: Change pathname for non-rename()able filesystems")
> from the security-testing tree.
> 
> The latter includes the change from the former, so I just used the latter.

Thank you.
Modification of security/tomoyo/realpath.c in 6ef0dd885ce8 is no longer needed.

In message "linux-next: Tree for July 22",
Stephen Rothwell wrote:
> The security-testing tree still has its build failure.
(...snipped...)
> Merging security-testing/next
> CONFLICT (content): Merge conflict in security/tomoyo/realpath.c

What should I do?
