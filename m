Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab2FYJcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:32:20 -0400
Received: from antcom.de ([188.40.178.216]:40731 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab2FYJcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:32:18 -0400
Message-ID: <4FE8301D.9050108@antcom.de>
Date: Mon, 25 Jun 2012 11:32:13 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: axel.lin@gmail.com, riyer@nvidia.com, michael.hennerich@analog.com,
        grant.likely@secretlab.ca, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        aletes.xgr@gmail.com
Subject: Re: [PATCH v6] input: keyboard: Add keys driver for the LPC32xx SoC
References: <1340549078-8973-1-git-send-email-stigge@antcom.de> <20120625070614.GA13876@core.coreip.homeip.net>
In-Reply-To: <20120625070614.GA13876@core.coreip.homeip.net>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry!

On 06/25/2012 09:06 AM, Dmitry Torokhov wrote:
> On Sun, Jun 24, 2012 at 04:44:38PM +0200, Roland Stigge wrote:
>> This patch adds a driver for the key scan interface of the LPC32xx SoC
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>>
> 
> This looks _very_ good, I just have a couple more comments:

Thanks for reviewing!

I think I'm addressing all of those points in my v7 patch.

Roland
