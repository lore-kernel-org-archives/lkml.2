Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab0HYCO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 22:14:57 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43078 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab0HYCOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 22:14:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VdjLFNg2tGivu6SyrrmrV6z6qJiZrF4IO5+CRavBIHCt8YI5SxcAo/C/PW7BRvAeob
         zHthRFOKdzBEjmBOi/+GCKrblZgDHV0V1wfE3wzdsDxZOweJ/knmz21bWYtQXAkz4TH3
         iIujL2VYek1mDq/jKzxedwXrvfEaBkT1zaIFQ=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: eric.y.miao@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH 0/1] added initial support for TPO TD043MTEA1 LCD display on Aspenite
Date: Tue, 24 Aug 2010 22:02:29 -0400
Message-Id: <1282701750-4949-1-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic support for TD043MTEA1 LCD display for Aspenite board.
This patch is generated against Eric Miao's pxa-linux-2.6 tree devel branch.

Mark F. Brown (1):
  pxa168: added initial support for TPO TD043MTEA1 LCD display on
    Aspenite

 arch/arm/configs/pxa168_defconfig       |   10 +++++
 arch/arm/mach-mmp/aspenite.c            |   59 +++++++++++++++++++++++++++++++
 arch/arm/mach-mmp/include/mach/pxa168.h |    8 ++++
 arch/arm/mach-mmp/pxa168.c              |    4 ++
 drivers/video/pxa168fb.c                |    4 +-
 5 files changed, 83 insertions(+), 2 deletions(-)

