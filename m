Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2ATQR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:17:27 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23475 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2ATQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:17:25 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19rOS5D8nZC7ctB2wpbL6uw
Subject: [PATCH 0/4] Some pinctrl fixes for pinmux modules
To: linux-kernel@vger.kernel.org
From: Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Date: Fri, 20 Jan 2012 08:17:18 -0800
Message-ID: <20120120161610.21955.25082.stgit@kaulin.local>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are few fixes mostly to make it easier to develop
loadable pinmux modules.

Regards,

Tony

---

Tony Lindgren (4):
      pinctrl: Free debugfs entries when unloading a pinmux driver
      pinctrl: Fix pinmux_hog_maps when ctrl_dev_name is not set
      pinctrl: Add checks for empty names in pinmux_search_function
      pinctrl: Fix some pinmux typos


 Documentation/pinctrl.txt |    2 +-
 drivers/pinctrl/core.c    |   14 +++++++++++++-
 drivers/pinctrl/core.h    |    3 +++
 drivers/pinctrl/pinmux.c  |   23 ++++++++++++++---------
 4 files changed, 31 insertions(+), 11 deletions(-)

-- 
Signature
