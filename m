Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab1LNRj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:39:58 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44300 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab1LNRj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:39:57 -0500
Date: Wed, 14 Dec 2011 17:39:50 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, keithp@keithp.com
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
In-Reply-To: <alpine.DEB.2.00.1112141724510.24407@skynet.skynet.ie>
Message-ID: <alpine.DEB.2.00.1112141738570.24407@skynet.skynet.ie>
References: <alpine.DEB.2.00.1112141724510.24407@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(ignore original, this one comes with a believable changelog).

> Hi Linus,
> 
> simple one just one pci ids patch from Alex,
> 
> I know Keith has some patches outstanding in his queue and I know they are 
> probably more than you'll want to merge at this point, I'm off until next 
> week, so Keith if you do send a pull request you may as well send to 
> Linus, since I know Linus can be more lenient on pulls which make the hw 
> he uses suck less :-)
> 
The following changes since commit 373da0a2a33018d560afcb2c77f8842985d79594:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2011-12-13 15:02:31 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon/kms: add some new pci ids

 include/drm/drm_pciids.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)
