Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2IMSyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:54:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62320 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2IMSyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:54:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6834"; a="236373183"
Date: Thu, 13 Sep 2012 11:53:42 -0700
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL 0/5] MSM changes for 3.7 merge window
Message-ID: <20120913185342.GA29823@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 5 pull requests for the MSM SoC.  The first 5 are
cleanups, fixes, devicetree, and some board changes that finally allow
us to build more than one SoC into a single kernel image.

The fifth patch is my merge, which can be used as a reference to the
intended merge resolution.

David

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
