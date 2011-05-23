Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab1EWJ6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:58:05 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52648 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab1EWJ6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:58:03 -0400
Message-ID: <4DDA2FA2.2000604@ti.com>
Date: Mon, 23 May 2011 10:57:54 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Graeme Gregory <gg@slimlogic.co.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux@slimlogic.co.uk" <linux@slimlogic.co.uk>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Subject: Re: [PATCH v4 1/2] REGULATOR: TWL6025: add support to twl-regulator
References: <1306095684-7732-1-git-send-email-gg@slimlogic.co.uk> <1306095684-7732-2-git-send-email-gg@slimlogic.co.uk> <20110522224857.GA15882@opensource.wolfsonmicro.com>
In-Reply-To: <20110522224857.GA15882@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/11 23:48, Mark Brown wrote:
> On Sun, May 22, 2011 at 09:21:23PM +0100, Graeme Gregory wrote:
>> Adding support for the twl6025. Major difference in the twl6025 is the
>> group functionality has been removed from the chip so this affects how
>> regulators are enabled and disabled.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
>> Since V1
>>
>> Use the features variable passed via platform data instead of calling
>> global function.
> 
> Change histories like this should usually come after the --- so things
> like git am strip them out of what actually ends up in git.

Applied.

Thanks

Liam
