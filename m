Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1BONvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:51:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57918 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1BONvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:51:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OMBYNB2dcdGx7qFL4LWHmooCexcAg5N/b87AihmDQpzHs1ktRs6Y2yXjc+75kHryTb
         +YbBxE593GAMwEtj2Ly3J0yjevddMxkNK16LYdmrxnsF8/qn3Dehalubyd1Ss/S+9XIa
         rJj7T8hsCQ+YhoZflF4nOLqWd8yr8kkMSgSSk=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH 0/2] Minor improvements to MSP pci support.
Date: Tue, 15 Feb 2011 19:42:31 +0530
Message-Id: <1297779151-26595-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

Following set of patch created againt linux-queue head .
Ignoring checkpatch warning (usage of volatile).

Anoop P A (2):
  Introduce MSP_HAS_PCI config option.
  Fix pci id check.

 arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h |    6 +++++-
 arch/mips/pci/Makefile                             |    4 +---
 arch/mips/pci/ops-pmcmsp.c                         |   16 +++++++++-------
 arch/mips/pmc-sierra/Kconfig                       |   12 +++++++++---
 4 files changed, 24 insertions(+), 14 deletions(-)

