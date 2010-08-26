Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0HZEsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 00:48:05 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36098 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab0HZEsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 00:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vpezG6G/sX5MpvSa9K8cLOY+wQTAyDzYLdSNXYYJBjjO7PcwS/pJOHNdJgxOpL3AuR
         CT5Xp2zxSf6eyB/ii1HPDaVKhB9QJnISeJyOM9R+L0CA9HsxMbBvTxmqhc2Q1UHXY7iJ
         jI5A8C1EtnPOnypBShzs50f50l4XG7Ubf96Fg=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: marek.vasut@gmail.com, linux-arm-kernel@lists.infradead.org,
        haojian.zhuang@marvell.com, eric.y.miao@gmail.com,
        linux-kernel@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH v3 0/2] added initial support for TPO TD043MTEA1 LCD display on Aspenite
Date: Wed, 25 Aug 2010 23:51:53 -0400
Message-Id: <1282794715-28640-1-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark F. Brown (2):
  pxa168: added framebuffer support code.
  pxa168: added initial support for TPO TD043MTEA1 LCD display on
    Aspenite

 arch/arm/mach-mmp/aspenite.c            |   60 +++++++++++++++++++++++++++++++
 arch/arm/mach-mmp/include/mach/pxa168.h |    8 ++++
 arch/arm/mach-mmp/pxa168.c              |    3 ++
 3 files changed, 71 insertions(+), 0 deletions(-)

