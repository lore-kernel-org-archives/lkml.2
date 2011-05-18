Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab1ERKmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:42:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34082 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab1ERKmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:42:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Y+u2+tseYVfx0hEcCziC89lSIqtKdkV4Ny4/1PZIDWQr15mnaDSuUArZw+2Z1QBKaa
         zfOC2ZccS4lSZwVOxxHl1K7JWGST0s5/bQVojoxOBYqJY3PVNQesVZDNkunZW8bahSeV
         iG7adUkUVcbgHqrV/DzHWW4JfRRIQbw4UxpJg=
From: "Cho, Yu-Chen" <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, segooon@gmail.com, huajun.li.lee@gmail.com,
        kkatuev@gmail.com, jj@chaosbits.net, imirkin@alum.mit.edu,
        devel@driverdev.osuosl.org, jlee@novell.com, acho@novell.com
Subject: [PATCH 0/7] staging/keucr: fix keucr coding style
Date: Wed, 18 May 2011 18:40:08 +0800
Message-Id: <cover.1305714525.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some .c .h files coding style.

Signed-off-by: Cho, Yu-Chen <acho@novell.com>

Cho, Yu-Chen (7):
  staging/keucr: fix keucr ms coding style
  staging/keucr: fix keucr msscsi coding style
  staging/keucr: fix keucr scsiglue coding style
  staging/keucr: fix keucr smilecc.c coding style
  staging/keucr: fix keucr smil.h coding style
  staging/keucr: fix keucr transport coding style
  staging/keucr : fix transport other code style

 drivers/staging/keucr/ms.c        |  693 +++++++++++++++++++++----------------
 drivers/staging/keucr/ms.h        |  338 ++++++++++---------
 drivers/staging/keucr/msscsi.c    |  219 +++++++------
 drivers/staging/keucr/scsiglue.c  |  157 +++++----
 drivers/staging/keucr/smil.h      |  291 ++++++++--------
 drivers/staging/keucr/smilecc.c   |  293 ++++++++--------
 drivers/staging/keucr/transport.c |  389 +++++++++++----------
 drivers/staging/keucr/transport.h |   81 +++--
 8 files changed, 1337 insertions(+), 1124 deletions(-)

