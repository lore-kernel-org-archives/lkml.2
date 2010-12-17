Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab0LQIKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 03:10:49 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:64685 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab0LQIKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 03:10:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=sI3Dui8+3KUEAZe9P0QwmjAC6gF/9cXdYCYZPiNZz+BkY3wsWFUMCMxrl2GkSw2zy7
         BjCmg3aly+2J2/+lS+8CMmCf/klS4ugwBIXRWZout++JgCKVhwttzUWAeYoq/3ChNCN/
         nX6CN1JSXebrwzhAYcWnBUpSx0YIHM1WI3JWE=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        chl.pixo@gmail.com, Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 0/2] Fix ft1000-pcmcia driver.
Date: Fri, 17 Dec 2010 09:13:10 +0100
Message-Id: <1292573592-3624-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches fix compilation errors in ft1000-pcmcia driver.
Driver was marked as BROKEN.

Thanks chl.pixo@gmail.com for his contribution and testing.

Marek Belisko (2):
  staging: ft1000-pcmcia: Fix compilation errors.
  staging: ft1000-pcmcia: Fix compilation warning.

 drivers/staging/ft1000/Kconfig                     |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c   |  286 +++++---------------
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    2 +-
 4 files changed, 70 insertions(+), 222 deletions(-)

