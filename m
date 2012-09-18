Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab2IROrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:47:11 -0400
Received: from antcom.de ([188.40.178.216]:53172 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150Ab2IROrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:47:07 -0400
Message-ID: <50588968.9090505@antcom.de>
Date: Tue, 18 Sep 2012 16:47:04 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        devicetree-discuss@lists.ozlabs.org, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH v2] spi/pl022: Devicetree support w/o platform data
References: <1347976433-1176-1-git-send-email-stigge@antcom.de> <201209181443.29025.arnd@arndb.de>
In-Reply-To: <201209181443.29025.arnd@arndb.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 04:43 PM, Arnd Bergmann wrote:
> On Tuesday 18 September 2012, Roland Stigge wrote:
>> Even with devicetree support, we needed platform data to provide some data,
>> leading to mixed device tree and platform data. This patch makes it possible to
>> provide all that information via device tree. Now, the data must be provided
>> via platform data or device tree completely.
>>
>> Only in case of DMA where a callback specification is necessary (dma_filter()),
>> platform data is the only option.
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks for reviewing.

Of the arm-soc.git / LPC32xx related adjustments, the dts patch is
obsolete now. But I will do a pull request for the other one (unchanged)
when the above spi-pl022 patch is subsystem-merged.

Roland
