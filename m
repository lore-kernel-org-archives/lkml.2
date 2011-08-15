Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1HOHb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:31:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40033 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab1HOHb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:31:57 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ilya Gorskin <Revent82@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v2 0/3] Staging: cx25821: fix style issues
Date: Mon, 15 Aug 2011 15:31:15 +0800
Message-Id: <1313393478-7068-1-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes various coding style issues in
drivers/staging/cx25821
--
 drivers/staging/cx25821/cx25821-audio-upstream.c   |   33 +++-----
 drivers/staging/cx25821/cx25821-audio-upstream.h   |    9 ++-
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |   86 ++++++++-----------
 .../staging/cx25821/cx25821-video-upstream-ch2.h   |   83 ++++++++++++++-----
 drivers/staging/cx25821/cx25821-video-upstream.c   |   16 ++---
 drivers/staging/cx25821/cx25821-video-upstream.h   |   78 ++++++++++++------
 6 files changed, 176 insertions(+), 129 deletions(-)
