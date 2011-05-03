Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1ECRwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:52:54 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36881 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab1ECRwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:52:53 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 18/23] intel_sst: intelmid_v2_control: correct jack event type
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:35:51 +0100
Message-ID: <20110503163542.24853.13121.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy CH Lin <andy_ch_lin@wistron.com>

Correct event type of audio jack while receiving long press event.

Signed-off-by: Andy CH Lin <andy_ch_lin@wistron.com>
Signed-off-by: Jekyll Lai <jekyll_lai@wistron.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intelmid_v2_control.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index 6f4caa5..547b8b1 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -1054,7 +1054,7 @@ static void nc_pmic_irq_cb(void *cb_data, u8 intsts)
 		present = 1;
 		jack_event_flag = 1;
 		buttonpressflag = 1;
-		mjack->jack.type = MID_JACK_HS_SHORT_PRESS;
+		mjack->jack.type = MID_JACK_HS_LONG_PRESS;
 	}
 
 	if (jack_event_flag)

