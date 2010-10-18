Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab0JRXE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:04:28 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49867 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab0JRXE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:04:27 -0400
Date: Tue, 19 Oct 2010 00:04:14 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm last radeon fix
Message-ID: <alpine.DEB.2.00.1010190003080.487@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

this just applies a hw cursor workaround from previous chips to cover the 
new Evergreen GPU family.

The following changes since commit 2b666ca4a68cbc22483b0f2e1ba3c0e59b01ae9e:

  Merge branch 'fix/misc' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 (2010-10-17 09:38:08 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (1):
      drm/radeon/kms: avivo cursor workaround applies to evergreen as well

 drivers/gpu/drm/radeon/radeon_cursor.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)
