Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0G2FOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 01:14:32 -0400
Received: from imr3.ericy.com ([198.24.6.13]:45808 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab0G2FN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 01:13:56 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Nick Cheng <nick.cheng@areca.com.tw>,
        James Smart <james.smart@emulex.com>,
        Alex Iannicelli <alex.iannicelli@emulex.com>,
        "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        Benjamin Thery <benjamin.thery@bull.net>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 5/6] powerpc/pci: Remove owner field from attribute initialization in PCI bridge init
Date: Wed, 28 Jul 2010 22:09:25 -0700
Message-ID: <1280380166-29196-6-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 arch/powerpc/sysdev/mv64x60_pci.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/mv64x60_pci.c b/arch/powerpc/sysdev/mv64x60_pci.c
index 198f288..77bb3f4 100644
--- a/arch/powerpc/sysdev/mv64x60_pci.c
+++ b/arch/powerpc/sysdev/mv64x60_pci.c
@@ -73,7 +73,6 @@ static struct bin_attribute mv64x60_hs_reg_attr = { /* Hotswap register */
 	.attr = {
 		.name = "hs_reg",
 		.mode = S_IRUGO | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size  = MV64X60_VAL_LEN_MAX,
 	.read  = mv64x60_hs_reg_read,
-- 
1.7.0.87.g0901d

