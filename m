Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1GGSRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:17:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41820 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab1GGSRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:17:39 -0400
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 0/2] Minor cleanups
Date: Thu,  7 Jul 2011 14:17:23 -0400
Message-Id: <1310062645-4344-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.6.131.g99019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I changed a Makefile to stop using a deprecated build flag
and fixed a spelling error.

Tracey Dent (2):
  Altera-stapl: Clean up makefile (-y instead of -objs)
  Ath6kl: TODO: Fix spelling :)

 drivers/staging/altera-stapl/Makefile |    2 +-
 drivers/staging/ath6kl/TODO           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.6.131.g99019

