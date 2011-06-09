Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab1FIWs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:48:56 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55353 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889Ab1FIWsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=mZmTpvJdWjGy5YyjJJTmZwuHDIOqtQRm8M+k43W8wCznu+Cle4Bh1qDQp7TiGn5K1k
         GtF9dKDNMlEw9VmcQJY8sqcCs9tJuDie47FzxyKdJW7bgRCd5gYFmkUPB6AOGU/Bj3xv
         TW/Yz8h1yvXIew15ul5zoXYh91EMhuoevrYjo=
Date: Thu, 9 Jun 2011 18:06:04 -0400
From: Jay Estabrook <jay.estabrook@gmail.com>
To: linux-alpha <linux-alpha@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Cc: Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Jay Estabrook <jay.estabrook@gmail.com>, airlied@linux.ie
Subject: [PATCH 0/3] alpha, drm: Update Alpha DRM support
Message-ID: <20110609180604.7cac8b5a.jay.estabrook_gmail.com@gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; alpha-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set fixes Alpha-specific support in the DRM code,
allowing Radeon KMS and the MGA driver to work properly on
Alpha-based machines.

Jay

Jay Estabrook (3):
  alpha, drm: Update Alpha DRM support
  alpha, drm: Cleanup Alpha support in DRM generic code
  alpha, drm: Remove obsolete Alpha support in MGA DRM code
  alpha, drm: Add Alpha support to Radeon DRM code

 drivers/gpu/drm/drm_bufs.c          |    3 ---
 drivers/gpu/drm/drm_vm.c            |    2 +-
 drivers/gpu/drm/mga/mga_drv.h       |   19 -------------------
 drivers/gpu/drm/radeon/radeon_ttm.c |   23 +++++++++++++++++++++++
 4 files changed, 24 insertions(+), 23 deletions(-)

---

