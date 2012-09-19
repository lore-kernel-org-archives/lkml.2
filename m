Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2ISPOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:14:12 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:19642 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754695Ab2ISPOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:14:07 -0400
Message-ID: <1348067642.4836.58.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v2 7/9] net/macb: ethtool interface: add register dump
 feature
From: Ben Hutchings <bhutchings@solarflare.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>, <havard@skinnemoen.net>,
        <linux-arm-kernel@lists.infradead.org>, <plagnioj@jcrosoft.com>,
        <patrice.vilchez@atmel.com>, <linux-kernel@vger.kernel.org>
Date: Wed, 19 Sep 2012 16:14:02 +0100
In-Reply-To: <20ebfb29f6f4a84d8ba20553e2d81cd456f438de.1348055112.git.nicolas.ferre@atmel.com>
References: <cover.1348055112.git.nicolas.ferre@atmel.com>
	 <20ebfb29f6f4a84d8ba20553e2d81cd456f438de.1348055112.git.nicolas.ferre@atmel.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.96.1.126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-19 at 13:55 +0200, Nicolas Ferre wrote:
> Add macb_get_regs() ethtool function and its helper function:
> macb_get_regs_len().
> The version field is deduced from the IP revision which gives the
> "MACB or GEM" information. An additional version field is reserved.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Reviewed-by: Ben Hutchings <bhutchings@solarflare.com>
[...]

Please also send the register dump decoder for the ethtool utility once
this series is accepted.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

