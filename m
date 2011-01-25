Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab1AYICf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:02:35 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44521 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1AYICf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:02:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QSmDHaYLFtkz77o7pstURZEBD+8uwtIM24u8eKZtm28bTI2o4SOmXl7ZKnnDOkwExE
         lBL87nTYDyn6mtO7c+TQ8h8naXF8E5YGVWGGSn7rb/l/VgDzlPaZHcvB7MrsLe3ucFvp
         4szh0PhFbizrIPfw7BgdpJ8taGMyCAyvGk/Og=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH 0/6] Various Enhancements for PMC-Sierra MSP SoC support
Date: Tue, 25 Jan 2011 13:48:32 +0530
Message-Id: <1295943512-19900-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

Following Series of patches add various enahancements for PMC-Sierra
MSP71xx family of SoC's platform hooks, including MIPS MT mode support
and support for various onchip devices like USB and Ethernet.  

Anoop P A (6):
  set up MSP VPE1 timer.
  Vectored interrupt support.
  MIPS MT kernel modes ( VSMP/SMTC ) support for MSP platforms.
  Platform support MSP onchip USB controller.
  Platform support for On-chip MSP ethernet devices.
  Cpu features overrides for msp platforms.
