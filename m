Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab0ILLK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 07:10:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52496 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab0ILLKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 07:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=JIn5YHyHnMqH7OP4R3ziVAlLM6yQCcY2pxDVN97rBFE8FIvMvkTqlxOVossNN1LINR
         PwpMtBAhrHgI4YwRdxI1Dw1RWNyqM50DvR4b6jgAhBsK+PMapr77A8Q+B3uzJgAyivsz
         F+VEG9jwXVcEpUFrRv3OGU32IGPquKuGnRGMY=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 0/2] trivial: fix some compilation warnings
Date: Sun, 12 Sep 2010 14:10:27 +0300
Message-Id: <1284289829-25425-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pretty trivial compilation warning fixes.

Felipe Contreras (2):
  autofs4: fix compilation warning
  mac80211: fix compilation warning

 fs/autofs4/root.c |    2 ++
 net/mac80211/tx.c |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

-- 
1.7.2.3

