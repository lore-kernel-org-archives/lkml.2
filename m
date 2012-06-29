Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942Ab2F2EWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 00:22:10 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44501 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2F2EWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 00:22:08 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 0/3] staging: sep: Cleanup
Date: Fri, 29 Jun 2012 01:19:21 -0300
Message-Id: <1340943564-19082-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kernel folks!

These patches makes a little cleanup in the sep module, removing some functions and macros.
These changes were just compile tested. So, if someone could review or test, I will be grateful!

Marcos Paulo de Souza (3):
  staging: sep: sep_crypto.c: Remove useless function crypto_sep_dump_message
  staging: sep: sep_crypto.c: Remove useless functions sep_dump and
    sep_dump_sg
  staging: sep: sep_driver_config.h: Remove unused macros

 drivers/staging/sep/sep_crypto.c        |  100 -------------------------------
 drivers/staging/sep/sep_driver_config.h |   65 --------------------
 2 files changed, 165 deletions(-)

-- 
1.7.10.2

