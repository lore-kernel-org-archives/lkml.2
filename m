Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1ECQxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:53:43 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45644 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab1ECQxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:53:41 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 20/23] sst: set default output and input device
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:38:04 +0100
Message-ID: <20110503163759.24853.16558.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lu Guanqun <guanqun.lu@intel.com>

Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intelmid_v2_control.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index 547b8b1..5e61fe8 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -1067,6 +1067,8 @@ static int nc_jack_enable(void)
 }
 
 struct snd_pmic_ops snd_pmic_ops_nc = {
+	.input_dev_id   =       DMIC,
+	.output_dev_id  =       INTERNAL_SPKR,
 	.set_input_dev	=	nc_set_selected_input_dev,
 	.set_output_dev =	nc_set_selected_output_dev,
 	.set_mute	=	nc_set_mute,

