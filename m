Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2DZKCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:02:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44048 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2DZKCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:02:38 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Staging: comedi: fix code clean up issues.
Date: Thu, 26 Apr 2012 15:32:16 +0530
Message-Id: <1335434540-13286-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes some coding style issues found by
checkpatch.pl script.

Ravishankar Karkala Mallikarjunayya (4):
      Staging: comedi: fix line over 80 character issue in cb_pcidda.c
      Staging: comedi: fix line over 80 character issue in daqboard2000.c
      Staging: comedi: fix line over 80 character issue in cb_pcimdas.c.
      Staging: comedi: fix line over 80 character issue in ni_at_a2150.c
  

     drivers/staging/comedi/drivers/cb_pcidda.c    |   72 +++++++++++++++++--------
     drivers/staging/comedi/drivers/cb_pcimdas.c   |   17 ++++--
     drivers/staging/comedi/drivers/daqboard2000.c |    9 ++-
     drivers/staging/comedi/drivers/ni_at_a2150.c  |   16 ++++--
     4 files changed, 80 insertions(+), 34 deletions(-)

---

	




In-Reply-To: 

