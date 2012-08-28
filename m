Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2H1Jux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 05:50:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45988 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2H1Juv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 05:50:51 -0400
Subject: Re: [PATCH v2 02/14] MFD: twl4030-audio: Convert to use
 devm_kzalloc
From: Tero Kristo <t-kristo@ti.com>
Reply-To: <t-kristo@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Benoit Cousson <b-cousson@ti.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <1344954162-7985-3-git-send-email-peter.ujfalusi@ti.com>
References: <1344954162-7985-1-git-send-email-peter.ujfalusi@ti.com>
	 <1344954162-7985-3-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Texas Instruments
Date: Tue, 28 Aug 2012 12:50:10 +0300
Message-ID: <1346147410.2182.96.camel@sokoban>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 17:22 +0300, Peter Ujfalusi wrote:
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

I think this one could use a short commit message, also about why
kfree():s are dropped (handled internally by devm_* etc.)

-Tero

