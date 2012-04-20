Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab2DTONa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:13:30 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36881 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032Ab2DTON2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:13:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_ZhdKtK8YKo1qc8g18XrdnrQRZw2aFSkW8x3koELU10EsHw@mail.gmail.com>
References: <1334829097-32084-1-git-send-email-jaswinder.singh@linaro.org>
	<20120419124204.GE3046@opensource.wolfsonmicro.com>
	<CAJe_ZhfbFq98fT56CS-q4VoU8wnybj-+swfB+Jrknd3Zmt9V8g@mail.gmail.com>
	<20120419162905.GA3084@opensource.wolfsonmicro.com>
	<CAJe_Zhd0H6kXBhqdynuZqhbcPq8ARWu5SMbs=hQT2n8stzRvXQ@mail.gmail.com>
	<20120420114602.GB3259@opensource.wolfsonmicro.com>
	<CAJe_ZhdKv_7fTj9ZhJE0JzmuhxEZn-JmSbHu615YMXoWZUei9A@mail.gmail.com>
	<20120420130134.GA5957@opensource.wolfsonmicro.com>
	<CAJe_ZhdKtK8YKo1qc8g18XrdnrQRZw2aFSkW8x3koELU10EsHw@mail.gmail.com>
Date: Fri, 20 Apr 2012 19:43:27 +0530
Message-ID: <CAJe_ZhfZL+MT3azNifD_UgU1Nx+K0r_=i0yd9B=3L2JJTuXKWg@mail.gmail.com>
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 April 2012 19:18, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>
>>  To repeat yet again you're not supposed to actually use dummy regulators,
>> you're supposed to fully specify the regulators on your platform.
>>
> I use dummy regulators for what they are meant for - until every platform
> completely define supplies for every consumer.
> We are not there yet, yet one 'ideal' consumer suffers because of that.
>
> If you ask me to go away and disable dummy and update all consumers
> and their platforms, then I say why not remove the concept of dummy
> altogether which only delays full compliance to the regulator api ?
>
Btw, by 'all platforms' I meant those based on my SoC. Popular term - machines.
