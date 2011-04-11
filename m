Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1DKIQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:16:10 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43268 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1DKIQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=OPIW8EoV0cC61tAZ47ATG4SEwm3Ipv7U0IAik0yb771TzZ1Jo5kX1g7ZChWjVvEBPz
         IuiKt5CvujeGiWe0Btkq+wPSPbVW0lhyz81kTY2IjmEydALhCIhof88px6xNrOtNAtzq
         5VisPGUhv8BQdE9UYgOBhf7qFOQkh5NP3gqhM=
From: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
To: fubar@us.ibm.com, andy@greyhouse.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Weiping=20Pan (=E6=BD=98=E5=8D=AB=E5=B9=B3) ?= 
	<panweiping3@gmail.com>
Subject: [PATCH 0/2] bonding:delete two unused variables
Date: Mon, 11 Apr 2011 16:17:23 +0800
Message-Id: <cover.1302509480.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found that variable alb_timer and rlb_interval_counter in struct
alb_bond_info are not used by other codes any more, so delete them.

Weiping Pan(潘卫平) (2):
  bonding:delete unused alb_timer
  bonding:delete unused rlb_interval_counter

 drivers/net/bonding/bond_alb.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

-- 
1.7.4

