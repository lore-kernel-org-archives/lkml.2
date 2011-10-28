Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1J1Lmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:42:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44992 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1J1Lms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:42:48 -0400
Date: Fri, 28 Oct 2011 14:42:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] drm/i915: fix if statement (bogus semi-colon)
Message-ID: <20111028114241.GA13603@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4EAA9536.01A7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semi-colon is a typo here and it makes the if statement
unconditional.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 66cd0b8..3a8d448 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1236,7 +1236,7 @@ static int i9xx_setup(void)
 		intel_private.gtt_bus_addr = reg_addr + gtt_offset;
 	}
 
-	if (needs_idle_maps());
+	if (needs_idle_maps())
 		intel_private.base.do_idle_maps = 1;
 
 	intel_i9xx_setup_flush();
