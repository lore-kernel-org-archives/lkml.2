Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab2BXInk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 03:43:40 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:40532
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755630Ab2BXIni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 03:43:38 -0500
Message-ID: <4F474DAD.1030302@compulab.co.il>
Date: Fri, 24 Feb 2012 10:43:25 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20120201 Thunderbird/9.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: stable@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: ARM: OMAP: patches for stable
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

There are several patches already in mainline, that should be also applied to stable:

40410715 (ARM: omap: fix oops in drivers/video/omap2/dss/dpi.c)				[3.2-stable]
d980e0f8 (ARM: omap: fix oops in arch/arm/mach-omap2/vp.c when pmic is not found)	[3.2-stable]

Can these, please be applied to stable?

Thanks

-- 
Regards,
Igor.
