Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab1DNRGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:06:10 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:37137 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756746Ab1DNRGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:06:09 -0400
Date: Thu, 14 Apr 2011 19:05:59 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mjg@redhat.com
Cc: maciej.rutecki@gmail.com
Subject: 2.6.39-rc1 nouveau regression (bisected)
Message-ID: <20110414170559.GA10768@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	airlied@redhat.com, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, mjg@redhat.com,
	maciej.rutecki@gmail.com
References: <20110403181206.GA19291@comet.dominikbrodowski.net>
 <20110407151129.GA24977@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment
In-Reply-To: <20110407151129.GA24977@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thought about CCing Linus to show him that 2.6.39-rcX isn't as "calm"
to everyone, but then chose to CC Maciej instead: Would you be so kind and
add this to your regression list? Thanks!

Since commit 38f1cff

    From: Dave Airlie <airlied@redhat.com>
    Date: Wed, 16 Mar 2011 11:34:41 +1000
    Subject: [PATCH] Merge commit '5359533801e3dd3abca5b7d3d985b0b33fd9fe8b' into dr

    This commit changed an internal radeon structure, that meant a new driver
    in -next had to be fixed up, merge in the commit and fix up the driver.

    Also fixes a trivial nouveau merge.

    Conflicts:
        drivers/gpu/drm/nouveau/nouveau_mem.c

booting my atom/NM10/ION2 system crashes hard during boot, right after
blanking the screen, and before the initramfs gets loaded. I just
re-checked: both parent commits ( 5359533 and 4819d2e ) do indeed work
just fine, but the merge commit ( 38f1cff ) fails, same as tip ( 85f2e68 ).

My previous reports (Apr 03, Apr 07) seem to have gotten lost (or ignored,
or both).

Best,
	Dominik
