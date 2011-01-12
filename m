Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab1ALQGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:06:37 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49701 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab1ALQGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:06:34 -0500
Message-Id: <20110112160551.722413413@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Wed, 12 Jan 2011 17:05:51 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] read-only remount fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

Here's an updated patchset that fixes a read-only remount race.  Could
you please add it to your vfs tree?

Also in git:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git read-only-remount-fixes.v3

Thanks,
Miklos
