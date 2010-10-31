Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab0JaWeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 18:34:01 -0400
Received: from mail.perches.com ([173.55.12.10]:3897 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab0JaWeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 18:34:00 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Whitcroft <apw@canonical.com>, dri-devel@lists.freedesktop.org,
        linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 0/4] Fix k.alloc switched arguments
Date: Sun, 31 Oct 2010 15:33:52 -0700
Message-Id: <cover.1288555098.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (4):
  drivers/gpu/drm/vmwgfx: Fix k.alloc switched arguments
  drivers/scsi/pmcraid.c: Fix k.alloc switched arguments
  drivers/staging/udlfb/udlfb.c: Fix k.alloc switched arguments
  scripts/checkpatch.pl: Add check for k.alloc GFP as first argument

 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c     |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c |    2 +-
 drivers/scsi/pmcraid.c                  |    4 ++--
 drivers/staging/udlfb/udlfb.c           |    2 +-
 scripts/checkpatch.pl                   |    5 +++++
 5 files changed, 10 insertions(+), 5 deletions(-)

-- 
1.7.3.1.g432b3.dirty

