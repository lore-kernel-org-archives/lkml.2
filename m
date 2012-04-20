Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab2DTNsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:48:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57076 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500Ab2DTNsR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:48:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120420130134.GA5957@opensource.wolfsonmicro.com>
References: <1334829097-32084-1-git-send-email-jaswinder.singh@linaro.org>
	<20120419124204.GE3046@opensource.wolfsonmicro.com>
	<CAJe_ZhfbFq98fT56CS-q4VoU8wnybj-+swfB+Jrknd3Zmt9V8g@mail.gmail.com>
	<20120419162905.GA3084@opensource.wolfsonmicro.com>
	<CAJe_Zhd0H6kXBhqdynuZqhbcPq8ARWu5SMbs=hQT2n8stzRvXQ@mail.gmail.com>
	<20120420114602.GB3259@opensource.wolfsonmicro.com>
	<CAJe_ZhdKv_7fTj9ZhJE0JzmuhxEZn-JmSbHu615YMXoWZUei9A@mail.gmail.com>
	<20120420130134.GA5957@opensource.wolfsonmicro.com>
Date: Fri, 20 Apr 2012 19:18:15 +0530
Message-ID: <CAJe_ZhdKtK8YKo1qc8g18XrdnrQRZw2aFSkW8x3koELU10EsHw@mail.gmail.com>
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 April 2012 18:31, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Apr 20, 2012 at 05:59:42PM +0530, Jassi Brar wrote:
>
>> That's what I have been trying to fix. My example might be fictitious but
>> I have a real scenario with omap_hsmmc (I was avoiding getting into that).
>
>> The dummy not just provide a place holder data structure for missing definition
>> of an available supply, but it also masks the fact that there might indeed be no
>> supply at all on the given machine.
>
>> As I said, atm the only option for a consumer is to know it via PD/DT.
>
> No.  You're failing to understand what dummy regulators are for.
>
I think I do understand what dummy regulators are for and also that
they are meant to go away some time in future.

>  To repeat yet again you're not supposed to actually use dummy regulators,
> you're supposed to fully specify the regulators on your platform.
>
I use dummy regulators for what they are meant for - until every platform
completely define supplies for every consumer.
We are not there yet, yet one 'ideal' consumer suffers because of that.

If you ask me to go away and disable dummy and update all consumers
and their platforms, then I say why not remove the concept of dummy
altogether which only delays full compliance to the regulator api ?

-j
