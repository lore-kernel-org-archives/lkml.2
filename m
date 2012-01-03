Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab2ACKKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 05:10:50 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34973 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab2ACKKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 05:10:47 -0500
Date: Tue, 3 Jan 2012 10:10:41 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fix
Message-ID: <alpine.DEB.2.00.1201031009360.10481@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1316706332-1325585441=:10481"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1316706332-1325585441=:10481
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

just a small fix for a possible oops in radeon.

Dave.

The following changes since commit 115e8e705e4be071b9e06ff72578e3b603f2ba65:

  Merge branch 'devicetree/merge' of git://git.secretlab.ca/git/linux-2.6 (2012-01-02 12:34:03 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alexander Müller (1):
      drm/radeon/kms/atom: fix possible segfault in pm setup

 drivers/gpu/drm/radeon/radeon_atombios.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)
--29444707-1316706332-1325585441=:10481--
