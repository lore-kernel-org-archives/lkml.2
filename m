Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1LICJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 21:09:59 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:42046 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1LICJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 21:09:57 -0500
X-SpamScore: 6
X-BigFish: VS6(z36e9nzzz1202hzzz2dh2a8h668h839h944h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 9 Dec 2011 10:09:50 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <kernel@pengutronix.de>, <shawn.guo@linaro.org>
Subject: imx cpufreq build failed
Message-ID: <20111209020948.GA28216@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      arch/arm/plat-mxc/cpufreq.o
arch/arm/plat-mxc/cpufreq.c:203: error: expected declaration specifiers or '...' before string constant
arch/arm/plat-mxc/cpufreq.c:203: warning: data definition has no type or storage class
arch/arm/plat-mxc/cpufreq.c:203: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
arch/arm/plat-mxc/cpufreq.c:203: warning: function declaration isn't a prototype
arch/arm/plat-mxc/cpufreq.c:204: error: expected declaration specifiers or '...' before string constant
arch/arm/plat-mxc/cpufreq.c:204: warning: data definition has no type or storage class
arch/arm/plat-mxc/cpufreq.c:204: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
arch/arm/plat-mxc/cpufreq.c:204: warning: function declaration isn't a prototype
arch/arm/plat-mxc/cpufreq.c:205: error: expected declaration specifiers or '...' before string constant
arch/arm/plat-mxc/cpufreq.c:205: warning: data definition has no type or storage class
arch/arm/plat-mxc/cpufreq.c:205: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
arch/arm/plat-mxc/cpufreq.c:205: warning: function declaration isn't a prototype
make[1]: *** [arch/arm/plat-mxc/cpufreq.o] Error 1
make: *** [arch/arm/plat-mxc] Error 2


Thanks
Richard

