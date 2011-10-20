Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab1JTQxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 12:53:42 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:60344 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055Ab1JTQxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 12:53:41 -0400
MIME-Version: 1.0
In-Reply-To: <20111020104943.GA2379@pengutronix.de>
References: <1319106779.8866.1.camel@phoenix>
	<20111020104943.GA2379@pengutronix.de>
Date: Thu, 20 Oct 2011 17:53:38 +0100
Message-ID: <CABS+qY1efSEF1dyqnmcQxg+Y7BmUpynZH2NoUY6Jn4TgF0P-9A@mail.gmail.com>
Subject: Re: [PATCH] ASoC: Set sgtl5000->ldo in ldo_regulator_register
From: "Girdwood, Liam" <lrg@ti.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Dong Aisheng <B29396@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 October 2011 11:49, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Thu, Oct 20, 2011 at 06:32:59PM +0800, Axel Lin wrote:
>> Otherwise calling ldo_regulator_remove() does not unregister regulator
>> and free memories.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>
>
> BTW I think it is better to CC "Dong Aisheng <B29396@freescale.com>"
> instead of Zeng Zhaoming; he was lately working with sgtl5000.
>
Acked-by: Liam Girdwood <lrg@ti.com>
