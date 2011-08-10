Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1HJA6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 20:58:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56837 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab1HJA6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 20:58:45 -0400
Date: Wed, 10 Aug 2011 10:58:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the security-testing tree
Message-Id: <20110810105840.cb0b3ac63c84b51b98029d8c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

After merging the security-testing tree, today's linux-next build
(powerpc ppc64_defconfig) failed like this:

fs/reiserfs/xattr_security.c: In function 'reiserfs_security_init':
fs/reiserfs/xattr_security.c:69:2: error: implicit declaration of function 'security_old_inode_init_security'

Caused by commit 9d8f13ba3f48 ("security: new
security_inode_init_security API adds function callback").  Forgotten
include?

I have used the security-testing tree from next-20110809 for today.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
