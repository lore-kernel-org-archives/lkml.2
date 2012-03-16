Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145Ab2CPItc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:49:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38928 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460Ab2CPItZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:49:25 -0400
Date: Fri, 16 Mar 2012 16:49:54 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Dong Aisheng <aisheng.dong@freescale.com>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v1 1/5] ARM: imx28: add basic dt support
Message-ID: <20120316084952.GG7758@S2101-09.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-2-git-send-email-b29396@freescale.com>
 <20120313172351.97C5E3E053B@localhost>
 <20120314124512.GG1180@shlinux2.ap.freescale.net>
 <20120314141643.GP3852@pengutronix.de>
 <20120315030206.GB13022@shlinux2.ap.freescale.net>
 <20321.37353.63115.664975@ipc1.ka-ro>
 <20120315105927.GE13022@shlinux2.ap.freescale.net>
 <20321.53468.310199.875966@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20321.53468.310199.875966@ipc1.ka-ro>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 12:22:04PM +0100, Lothar Waßmann wrote:
...
> An intermediate solution could be using OF_DEV_AUXDATA to pass a
> platform_data struct that may contain a MAC address set up by the
> platform code.
> 
+1

-- 
Regards,
Shawn
