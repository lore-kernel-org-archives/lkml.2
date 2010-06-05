Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab0FEQEv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:04:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48515 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933610Ab0FEQEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:04:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=c+KRBJmfDoC47OWphIl6DwSW3z2lUsD04nwqtjB+ZkqoVwYrZ2/I+BFOqdv/x/+7pd
         zJRo3gnTxPwHmrstEuj/dfQ2gnI6o8UPaJHIB/qFEHZ++H8iqEvFLLtaX3M6vR62VqdH
         2u4UXq0yhEqklrN+Sv9dJi/cU1nGwe2dxMKgw=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 0/7] *** SUBJECT HERE ***
Date: Sat,  5 Jun 2010 18:04:18 +0200
Message-Id: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
To: Arnaud Patard <apatard@mandriva.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnaud,

here you can find a few patches that remove unused code, please review.

thanks,
riccardo

Riccardo Magliocchetti (7):
  Remove linux version ifdef.
  Remove WIN* specific code.
  Remove TC specific code.
  Remove X specific code.
  Remove linux kernel specific ifdefery since it is now the only    
    platform supported.
  More osdef.h cleanup
  Fixup compile warnings on x86-64.

 drivers/staging/xgifb/XGI_accel.c   |  216 ------------------
 drivers/staging/xgifb/XGI_accel.h   |   13 --
 drivers/staging/xgifb/XGI_main.h    |  118 +----------
 drivers/staging/xgifb/XGI_main_26.c |   41 +---
 drivers/staging/xgifb/osdef.h       |  119 ----------
 drivers/staging/xgifb/vb_def.h      |    2 -
 drivers/staging/xgifb/vb_ext.c      |  329 ----------------------------
 drivers/staging/xgifb/vb_ext.h      |    3 -
 drivers/staging/xgifb/vb_init.c     |   55 +-----
 drivers/staging/xgifb/vb_setmode.c  |  409 +----------------------------------
 drivers/staging/xgifb/vb_util.c     |   59 -----
 drivers/staging/xgifb/vgatypes.h    |  118 +----------
 12 files changed, 14 insertions(+), 1468 deletions(-)

