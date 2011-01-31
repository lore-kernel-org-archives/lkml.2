Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab1AaMrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:47:25 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:59606 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752968Ab1AaMrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:47:24 -0500
Message-ID: <4D46AFAB.3070805@metafoo.de>
Date: Mon, 31 Jan 2011 13:48:43 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Arun MURTHY <arun.murthy@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.miao@linaro.org>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Hemanth V <hemanthv@ti.com>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Bill Gatliff <bgat@billgatliff.com>
Subject: Re: [RFC] add pwmlib support
References: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de> <4D447E5E.6060007@metafoo.de> <F45880696056844FA6A73F415B568C6953739F1986@EXDCVYMBSTM006.EQ1STM.local> <20110131075408.GH9041@pengutronix.de>
In-Reply-To: <20110131075408.GH9041@pengutronix.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 08:54 AM, Sascha Hauer wrote:
> On Mon, Jan 31, 2011 at 04:35:33AM +0100, Arun MURTHY wrote:
>> Hi Sascha,
>>
>>>> I Cced the people working with PWMs in the kernel in the hope that
>>> they can
>>>> give input on what's missing / wrong in this implementation
>>>>
>>>> Sascha
>>>>
>>>
>>> Hi
>>>
>>> There have been two other proposals for a generic PWM api during the
>>> last year.
>>> You might want to take a look at them.
>>>
>>> https://lkml.org/lkml/2010/2/9/275
>>> https://lkml.org/lkml/2010/9/28/107
>>>
>>> I've added Bill Gatliff and Arun Murthy to Cc.
>>>
>>
>> As said by Lars, we already have developed the pwm core driver and
>> progressing towards aligning the existing pwm drivers to the pwm core
>> driver.
>> These set of patches are expected to be out in LKML by this week.
> 
> Nice, problem solved without me having to work on it ;).

I wouldn't call it problem solved yet.
I liked your approach better so far, but lets see how the next iteration of Aruns
patches turn out.

- Lars
