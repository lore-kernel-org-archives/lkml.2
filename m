Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2GPML4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:11:56 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:45324 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182Ab2GPMLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:11:54 -0400
Message-ID: <50040502.30603@ti.com>
Date: Mon, 16 Jul 2012 17:41:46 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, loml <linux-omap@vger.kernel.org>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH RFT] regulator: twl: Fix list_voltate for twl6030ldo_ops
References: <1342434670.4717.6.camel@phoenix> <50040440.80703@ti.com>
In-Reply-To: <50040440.80703@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I seemed to have messed up with the underlining.

On Monday 16 July 2012 05:38 PM, Rajendra Nayak wrote:
> [    0.337341] V1V8: 1800 mV normal standby
> [    0.338531] V2V1: 2100 mV normal standby
> [    0.339813] VMMC: 1200 <--> 3000 mV at 3100 mV normal standby
>                      ^^^^^^^^

I meant 3100 mV normal standby was wrong.

> [    0.341278] VPP: 1800 <--> 2500 mV at 2000 mV normal standby
>                      ^^^^^^^^^

2000 mV being wrong here.

> [    0.343505] VCXIO: 1800 mV normal standby
> [    0.343597] VCXIO: supplied by V2V1
> [    0.345855] VDAC: 1800 mV normal standby
> [    0.345947] VDAC: supplied by V2V1
> [    0.347717] VAUX2_6030: 1200 <--> 2800 mV at 1900 mV normal standby
>                          ^^^^^^^^

1900 mV here..

> [    0.349212] VAUX3_6030: 1000 <--> 3000 mV at 1300 mV normal standby
>                          ^^^^^^^^

and 1300 mV here.

