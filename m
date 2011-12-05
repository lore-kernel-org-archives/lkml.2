Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1LEHUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 02:20:13 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:39524 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482Ab1LEHUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 02:20:08 -0500
Message-ID: <4EDC709B.1050709@ti.com>
Date: Mon, 05 Dec 2011 12:49:55 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com,
        linaro-dev@lists.linaro.org, olof@lixom.net,
        Michael Hennerich <michael.hennerich@analog.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Zeng Zhaoming <b32542@freescale.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH v5 3/4] regulator: pass additional of_node to regulator_register()
References: <1321615040-13257-1-git-send-email-rnayak@ti.com>	<1321615040-13257-4-git-send-email-rnayak@ti.com> <CAJuYYwRa=AGZ+Chuj+v49EHE+bOuoCWxhmDUO35BoZK2g97FQg@mail.gmail.com>
In-Reply-To: <CAJuYYwRa=AGZ+Chuj+v49EHE+bOuoCWxhmDUO35BoZK2g97FQg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Documentation/power/regulator/regulator.txt would also require an
> update the reflect the change in api.

Thanks Thomas, I just sent a patch to fix this up.

regards,
Rajendra

>
> Thanks,
> Thomas.
>
> [...]

