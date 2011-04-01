Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1DAGlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:41:14 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58178 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab1DAGlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:41:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=HDP1OdLxWPHwGZeN9ZahoLMUiSDc7dz9qH9z2I9/bzIOGXycWY3639WROGw9XOizuN
         QdtijQ3sXVmSBwnys92Ly2hqIhYTnvVqi5pHBBwYzIFuzefONnMRMIXxAvWs4/QRDVd9
         WFz5ypIRWHH3hEqbq9HjLPGt82HTNjrmbRx4I=
From: "Cho, Yu-Chen" <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, segooon@gmail.com, huajun.li.lee@gmail.com,
        kkatuev@gmail.com, devel@driverdev.osuosl.org, jlee@novell.com,
        acho@novell.com
Subject: [PATCH 0/5] staging/keucr: use pr_<level> for messages
Date: Fri,  1 Apr 2011 14:38:38 +0800
Message-Id: <cover.1301638704.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cho, Yu-Chen <acho@novell.com>

  staging/keucr: init use pr_<level> for messages
  staging/keucr: msscsi use pr_<level> for messages
  staging/keucr: scsiglue use pr_<level> for messages
  staging/keucr: smilmain use pr_<level> for messages
  staging/keucr: transport usb use pr_<level>

 drivers/staging/keucr/init.c      |   95 ++++++++++++-------------
 drivers/staging/keucr/msscsi.c    |   29 +++++---
 drivers/staging/keucr/scsiglue.c  |   35 +++++----
 drivers/staging/keucr/smilmain.c  |   16 +++--
 drivers/staging/keucr/transport.c |  140 +++++++++++++++++++-----------------
 drivers/staging/keucr/usb.c       |   88 ++++++++++++-----------
 6 files changed, 210 insertions(+), 193 deletions(-)

