Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab0JEKbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:31:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56684 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab0JEKbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:31:48 -0400
Message-Id: <20101005103108.288743609@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 05 Oct 2010 12:31:08 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] read-only remount fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

This series fixes some of the races and other bugs in the read-only
remount code.  Please review.

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git read-only-remount-fixes

Thanks,
Miklos
---
