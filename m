Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab1AJMOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 07:14:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33385 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1AJMOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 07:14:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=KgKZxrMMFzC5aWXMKgyDcFk8stbx5OJOytgiEuuDXNLLLyg+keM3L1iT8P/hTdck+A
         qaujqAwmeVdnGvrlxIaED7YtgS2RTnN5tBmw348gKeAmfmM3wSSTno1HyqJdNSADAIib
         04NYUP034TNgfsaab4lxIS98STcS5+b8v9DIQ=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2] Fix building ft1000-pcmcia driver.
Date: Mon, 10 Jan 2011 13:14:27 +0100
Message-Id: <1294661668-21051-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patche fix compilation errors in ft1000-pcmcia driver.
Driver was marked as BROKEN.

Thanks chl.pixo@gmail.com for his contribution and testing.

Changes from v1 to v2:
- use pcmcia_get_mac_from_cis() instead self implemented function
suggested by (Dominik Brodowski <linux@dominikbrodowski.net>)

Marek Belisko (1):
  staging: ft1000-pcmcia: Fix compilation errors.

 drivers/staging/ft1000/Kconfig                     |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c   |  263 +++-----------------
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.h   |    1 -
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |   34 ++--
 5 files changed, 55 insertions(+), 247 deletions(-)
 delete mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.h

