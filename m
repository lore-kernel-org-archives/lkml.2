Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965579Ab2JDIlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:41:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45704 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998Ab2JDIlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:41:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6854"; a="245525462"
Message-ID: <506D4BCD.3020402@codeaurora.org>
Date: Thu, 04 Oct 2012 01:41:49 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: arm@kernel.org
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: arm-soc maintainer entry
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is the arm@kernel.org alias going to be added into the MAINTAINERS file?
Should anybody be sending mails to this address?

It seems I asked this over a year ago and the response was positive but
nothing ever happened[1]. Maybe something like below? I only ask because
get_maintainer.pl isn't picking up this email.

diff --git a/MAINTAINERS b/MAINTAINERS
index ecd8796..0e1ec23 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -606,6 +606,14 @@ W: http://www.arm.linux.org.uk/
 S:     Maintained
 F:     arch/arm/

+ARM SUB-ARCHITECTURES
+M:     arm@kernel.org
+L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:     MAINTAINED
+F:     arch/arm/mach-*/
+F:     arch/arm/plat-*/
+T:     git git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
+
 ARM PRIMECELL AACI PL041 DRIVER
 M:     Russell King <linux@arm.linux.org.uk>
 S:     Maintained

[1] https://lkml.org/lkml/2011/7/26/307

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

