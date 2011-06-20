Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1FTMY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 08:24:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56152 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab1FTMYz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:24:55 -0400
From: "Premi, Sanjeev" <premi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Tushar Behera <tushar.behera@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "Nilofer, Samreen" <samreen@ti.com>
Date: Mon, 20 Jun 2011 17:54:35 +0530
Subject: RE: [PATCH 1/2] config: omap2+: force fb and dss support as	built-in
Thread-Topic: [PATCH 1/2] config: omap2+: force fb and dss support as
	built-in
Thread-Index: AcwvRHtwTfA+gRnHRA+VBWaRiXHxJQAAGQpg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024D625A86@dbde02.ent.ti.com>
References: <1308566761-2850-1-git-send-email-tushar.behera@linaro.org>
 <1308566761-2850-2-git-send-email-tushar.behera@linaro.org>
 <B85A65D85D7EB246BE421B3FB0FBB593024D625A5C@dbde02.ent.ti.com>
 <20110620122032.GJ2082@n2100.arm.linux.org.uk>
In-Reply-To: <20110620122032.GJ2082@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk] 
> Sent: Monday, June 20, 2011 5:51 PM
> To: Premi, Sanjeev
> Cc: Tushar Behera; linux-kernel@vger.kernel.org; 
> linux-arm-kernel@lists.infradead.org; 
> linux-fbdev@vger.kernel.org; linux-omap@vger.kernel.org; 
> tony@atomide.com; lethal@linux-sh.org; 
> linaro-dev@lists.linaro.org; patches@linaro.org; Nilofer, Samreen
> Subject: Re: [PATCH 1/2] config: omap2+: force fb and dss 
> support as built-in
> 
> On Mon, Jun 20, 2011 at 05:37:07PM +0530, Premi, Sanjeev wrote:
> > [sp] Instead of changing the omap2plus_defconfig, shouldn't the
> >      board specific file be fixed instead?
> 
> The board specific configuration files in the mainline kernel are
> deprecated and are gradually being removed.
> 
[sp] I didn't mean board specific config file, but:
     linux-linaro-2.6.39/arch/arm/mach-omap2/board-rx51-video.c

~sanjeev