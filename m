Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab0LVJxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 04:53:39 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:55442 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753Ab0LVJxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 04:53:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJRZEU15Lcps/2dsb2JhbACkFHTCX4VJBA
Date: Wed, 22 Dec 2010 20:53:32 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@googlemail.com>, eparis@redhat.com
Subject: [announce] vfs-scale git tree update
Message-ID: <20101222095332.GA3430@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git

Branch is:

    vfs-scale-working

Changes since last posting:
* Fix for the cgroupfs crash (probably temporary until Al's fixes are
  merged).
* Fix a couple of bisectability bugs.
* Fix a race in disconnected dentry alias handling causing NFS to explode
  under load. Basically the patch to split dentry hash locks needs to
  lock the s_anon list with a seperate lock, which it wasn't doing
  properly in the d_move() code.

Thanks to all testers.

