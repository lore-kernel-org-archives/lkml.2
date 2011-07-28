Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1G1SZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 14:25:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49071 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1G1SZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 14:25:46 -0400
MIME-Version: 1.0
In-Reply-To: <CABE8wwstQaFpVdQ+uhYzadGj_cDXwVPHMQtRJWMmSS146uEzYg@mail.gmail.com>
References: <CABE8wwt8J_r9cExG+EAqqK=XVmAyLYhv+-T49Rr9hhKudD8n2g@mail.gmail.com>
	<CAJe_ZheVyLk-yqyF_XO80xX3j7_7mDPnv-me+n=X_hNWycSLwg@mail.gmail.com>
	<CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com>
	<CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com>
	<CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com>
	<CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
	<1311740499.1536.56.camel@vkoul-udesk3>
	<CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com>
	<1311757347.1536.103.camel@vkoul-udesk3>
	<CAJe_Zhd+Z4-=xDzFrd3ARuKZkUAo6n_miQgdSADY9Uk6uhkqhw@mail.gmail.com>
	<20110727203710.GB5028@flint.arm.linux.org.uk>
	<CAJe_ZhcggEW1wfF8EVy-qgfa194B+-qifongLOvPwVg5O9AcBg@mail.gmail.com>
	<CABE8wwstQaFpVdQ+uhYzadGj_cDXwVPHMQtRJWMmSS146uEzYg@mail.gmail.com>
Date: Thu, 28 Jul 2011 23:55:45 +0530
Message-ID: <CAJe_ZhcDSamQCu1UQB08Bp8CJMRTGncFLFUpHCP3peRcye-D9g@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>, "Koul, Vinod" <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 July 2011 23:44, Williams, Dan J <dan.j.williams@intel.com> wrote:
> On Thu, Jul 28, 2011 at 10:54 AM, Jaswinder Singh
> <jaswinder.singh@linaro.org> wrote:
>> On 28 July 2011 02:07, Russell King <rmk@arm.linux.org.uk> wrote:
>>>
>>>> On a serious note, my proposal, and the reply, shows the possibility
>>>> of having :-
>>>> a) Client drivers that are truly platform agnostic -- no platform_data
>>>> poking for
>>>>       channel selection
>>>
>>> I really doubt that's even possible.  Take this setup:
>>
>> I don't want to suggest anything wrong just because I didn't understand
>> your h/w.
>> I hope you will be kind enough to help me better understand your setup,
>> so that I have a fair chance to present my proposal.
>
> I don't understand all the slave usage models but the proposal seems
> fragile.  It wants to encode a whole bunch of arch specific details
> into a 32-bit code, but it still seems to me that there will always be
> platform specific details that don't fit the code.  Especially when we
> are still striving to ensure common behavior across drivers.  It seems
> the first step should be getting a few instances of a client driver
> interfacing with multiple dma drivers (via platform specific
> machinery) and see if anything common falls out of those
> implementations that can be pulled into dmaengine.  The proposal seems
> to be addressing a problem that we don't yet have (several clients
> associating with multiple channels in disparate and un-maintainable
> ways).

Dan, did you get time to read https://lkml.org/lkml/2011/7/28/97 ?

And please try to pose a scenario(however extreme) that you think
can't be handled by the mechanism.
Let us either kill the proposal or start implementing it if it's good.
