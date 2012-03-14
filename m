Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab2CNHJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:09:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45808 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2CNHJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:09:25 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: Dong Aisheng <aisheng.dong@freescale.com>
Subject: Re: [PATCH v1 2/5] mmc: mxs-mmc: add dt probe support
Date: Wed, 14 Mar 2012 08:09:22 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Dong Aisheng-B29396" <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Guo Shawn-R65073" <r65073@freescale.com>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com> <201203140658.25854.marek.vasut@gmail.com> <20120314065512.GB25735@shlinux2.ap.freescale.net>
In-Reply-To: <20120314065512.GB25735@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203140809.22676.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dong Aisheng,

> On Wed, Mar 14, 2012 at 01:58:25PM +0800, Marek Vasut wrote:
> > Dear Dong Aisheng,
> > 
> > > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> 
> ........
> 
> > > +static const struct of_device_id mxs_mmc_dt_ids[] = {
> > > +	{ .compatible = "fsl,imx23-mmc", .data = NULL, },
> > > +	{ .compatible = "fsl,imx28-mmc", .data = NULL, },
> > 
> > Do you really need two distinct ones here?
> 
> Hmm, my original purpose is to put soc difference data in .data
> to remove cpu_is_* function calls in the driver later.
> Do you think if any issue?
> 

Well, what's the difference between the interfaces on mx233 and mx28? Is it 
something that can't be encoded otherwise? I think they're not so different.

Best regards,
Marek Vasut
