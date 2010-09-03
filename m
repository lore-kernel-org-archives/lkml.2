Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab0ICX3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 19:29:05 -0400
Received: from mail.perches.com ([173.55.12.10]:1285 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab0ICX3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 19:29:04 -0400
From: Joe Perches <joe@perches.com>
To: Christophe Henri RICARD <christophe-h.ricard@st.com>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, tpmdd-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] tpm_stm_st19+i2c: use pr_<level> and cleanups
Date: Fri,  3 Sep 2010 16:28:59 -0700
Message-Id: <cover.1283556028.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <0B9F1C5B86169C4EA9D042C251022E49105CD81DE1@SAFEX1MAIL3.st.com>
References: <0B9F1C5B86169C4EA9D042C251022E49105CD81DE1@SAFEX1MAIL3.st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There appears to be a missing break in wait_until_good_shape.
Other than that, just some neatening.

Joe Perches (2):
  drivers/char/tpm/tpm_stm_st19_i2c.c: Use pr_fmt, pr_<level> and FUNC_ENTER
  drivers/char/tpm/tpm_stm_st19_i2c.c: Add missing break and neatening

 drivers/char/tpm/tpm_stm_st19_i2c.c |  215 ++++++++++++++++++----------------
 1 files changed, 114 insertions(+), 101 deletions(-)

-- 
1.7.2.19.g9a302

