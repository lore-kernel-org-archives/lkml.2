Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab1F3VzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:55:07 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38255 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab1F3VzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:55:05 -0400
Date: Thu, 30 Jun 2011 22:54:24 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] another radeon minor fix
Message-ID: <alpine.DEB.2.00.1106302253350.32177@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixes some gpus in the rv770 range so they can turn on.

Dave.

The following changes since commit 0e90ed0e8b9b1c25040442f1d20c799751b1e727:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2011-06-30 10:44:52 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (1):
      drm/radeon/kms: Fix chremap setup on RV770 CE

 drivers/gpu/drm/radeon/rv770.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)
