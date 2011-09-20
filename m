Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab1ITQAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:00:11 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:31217
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554Ab1ITQAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:00:09 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Message-ID: <4E78B883.3000808@freescale.com>
Date: Tue, 20 Sep 2011 11:00:03 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: fsl: Fix error handling if platform_device_add
 fails
References: <1316502540.4269.1.camel@phoenix>
In-Reply-To: <1316502540.4269.1.camel@phoenix>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> Call platform_device_put() instead of platform_device_unregister() if
> platform_device_add() fails.

What's wrong with calling platform_device_unregister()?

-- 
Timur Tabi
Linux kernel developer at Freescale

