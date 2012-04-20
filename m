Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab2DTNOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:14:53 -0400
Received: from antcom.de ([188.40.178.216]:34628 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab2DTNOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:14:51 -0400
Message-ID: <4F916146.1080904@antcom.de>
Date: Fri, 20 Apr 2012 15:14:46 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: grant.likely@secretlab.ca, robherring2@gmail.com, vitalywool@gmail.com,
        khali@linux-fr.org, ben-linux@fluff.org, rob.herring@calxeda.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        Srinivas Bakki <srinivas.bakki@nxp.com>
Subject: Re: [PATCH v5] i2c: Add device tree support to i2c-pnx.c
References: <1334913755-10466-1-git-send-email-stigge@antcom.de> <20120420120950.GA15613@pengutronix.de>
In-Reply-To: <20120420120950.GA15613@pengutronix.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/20/2012 02:09 PM, Wolfram Sang wrote:
>> Signed-off-by: Roland Stigge <stigge@antcom.de> Reviewed-by: Arnd
>> Bergmann <arnd@arndb.de> Acked-by: Wolfram Sang
>> <w.sang@pengutronix.de>
> 
> NACK! I said the approach of dropping "timeout" is OK, but unless I
> say "you may add my ack after changing this and that", please do
> not automatically add my ack. Doesn't hurt here, since I have to
> pick it up anyway.

Sorry - my apologies! Removing for next re-post.

>> Changes since v4: * Removed OF timeout property (to be added
>> later when there is consensus about how to call and handle it) *
>> Changed clock-frequency example to decimal
> 
> Thanks, I just noticed. Please drop (more precise: remove) the 
> "slave-addr" for the same reasons as "timeout".

OK, will do.

>> ret = request_irq(alg_data->irq, i2c_pnx_interrupt, -			0,
>> pdev->name, alg_data); +			  0, pdev->name, alg_data);
> 
> I know that checkpatch complains about this, but I'd prefer to
> avoid such changes unless the code before was really unreadable.

OK!

Roland
