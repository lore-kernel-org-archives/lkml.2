Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab2ECPNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:13:19 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:33167 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755939Ab2ECPNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:13:17 -0400
Message-ID: <4FA2A08C.5000403@ti.com>
Date: Thu, 03 May 2012 18:13:16 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120503 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
References: <1336049665-27777-1-git-send-email-peter.ujfalusi@ti.com> <1336049665-27777-3-git-send-email-peter.ujfalusi@ti.com> <20120503132004.GB14296@sirena.org.uk> <4FA2881B.6010902@ti.com> <20120503145248.GJ3955@opensource.wolfsonmicro.com>
In-Reply-To: <20120503145248.GJ3955@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 05:52 PM, Mark Brown wrote:
> Are you sure there aren't any boards out there which rely on the
> interrupt base (eg, using a GPIO with the IRQ output of a chip)?

Yes, I'm sure.

-- 
Péter
