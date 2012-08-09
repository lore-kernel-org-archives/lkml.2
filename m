Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab2HIMKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:10:24 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:39117 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153Ab2HIMKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:10:21 -0400
Message-ID: <5023A8AE.5050300@ti.com>
Date: Thu, 09 Aug 2012 15:10:22 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120723 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Sergio Aguirre <saaguirre@ti.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/3] mfd: twl6040: Add twl6040-gpio child
References: <1342603220-13287-1-git-send-email-peter.ujfalusi@ti.com> <1342603220-13287-3-git-send-email-peter.ujfalusi@ti.com> <CACRpkdZJcy5HOZkjMCVJW5beExoCHOBb=BiB4GOGR7sM+5Xsww@mail.gmail.com> <5016967D.2020104@ti.com> <20120809115531.GB8474@sirena.org.uk>
In-Reply-To: <20120809115531.GB8474@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 02:55 PM, Mark Brown wrote:
> On Mon, Jul 30, 2012 at 05:13:17PM +0300, Peter Ujfalusi wrote:
> 
>> If the board needs the gpo driver, but in the driver(s) I need to check for
>> the existence of the "ti,twl6040-gpo" node and check if the status is "okay".
>> I think it is easier to just get the value of "ti,use-gpo", if it exist and it
>> is 1 I enable the GPIO driver otherwise I don't.
> 
> Will having the GPIO driver actually cause any problems if it's not in
> use?  It's not like things like RTC which are directly visible to
> userspace and so can create problems if they're non-functional, unless
> it does something like grab resources that might be needed by another
> subfunction driver there's not really a substantial cost in just
> instantiating it (people who are really space pressured probably won't
> build the driver in in the first place).

Fair enough, I'll make the change for the v2.

-- 
Péter
