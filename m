Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab2F0T05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:26:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54868 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab2F0T0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:26:55 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, grabner@icg.tugraz.at, stefanha@gmail.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 0/9] Replaced the calls to strict_strtoul() in the line6 driver
Date: Wed, 27 Jun 2012 21:25:54 +0200
Message-Id: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced the strict_strtoul() calls in the line6 driver and adopted the
interfaces of some functions functions affected by the changes.

Johannes Thumshirn (9):
  staging: line6: changed interface of line6_transmit_parameter()
  staging: line6: Changed some strict_strtouls to kstrtou8
  staging: line6: changed interface of line6_pod_transmit_parameter()
  staging: line6: adjusted interface of line6_send_program()
  staging: line6: changed interface of pod_send_channel()
  staging: line6: control.c eliminate strict_strtoul() in
    pod_set_param_int()
  staging: line6: Exchanged strict_strtoul with kstrtou8() in
    pod.c:pod_resolve()
  staging: line6: Changed strict_strtoul() to kstrtou8() in
    pod_set_channel()
  staging: line6: Changed strict_strtoul() to kstrtou8() in
    pod_set_midi_postprocess()

 drivers/staging/line6/control.c |    4 ++--
 drivers/staging/line6/driver.c  |    4 ++--
 drivers/staging/line6/driver.h  |    4 ++--
 drivers/staging/line6/pod.c     |   16 ++++++++--------
 drivers/staging/line6/pod.h     |    2 +-
 drivers/staging/line6/variax.c  |    8 ++++----
 6 files changed, 19 insertions(+), 19 deletions(-)

-- 
1.7.7.6

