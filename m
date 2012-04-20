Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab2DTTLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:11:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44574 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421Ab2DTTLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:11:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120420184806.GA3092@opensource.wolfsonmicro.com>
References: <20120419124204.GE3046@opensource.wolfsonmicro.com>
	<CAJe_ZhfbFq98fT56CS-q4VoU8wnybj-+swfB+Jrknd3Zmt9V8g@mail.gmail.com>
	<20120419162905.GA3084@opensource.wolfsonmicro.com>
	<CAJe_Zhd0H6kXBhqdynuZqhbcPq8ARWu5SMbs=hQT2n8stzRvXQ@mail.gmail.com>
	<20120420114602.GB3259@opensource.wolfsonmicro.com>
	<CAJe_ZhdKv_7fTj9ZhJE0JzmuhxEZn-JmSbHu615YMXoWZUei9A@mail.gmail.com>
	<20120420130134.GA5957@opensource.wolfsonmicro.com>
	<CAJe_ZhdKtK8YKo1qc8g18XrdnrQRZw2aFSkW8x3koELU10EsHw@mail.gmail.com>
	<20120420144256.GA6828@opensource.wolfsonmicro.com>
	<CAJe_ZhdzuHo8P5WHguKMaikht8aN4RU-j_Q9FB+xOSw=roFZ=w@mail.gmail.com>
	<20120420184806.GA3092@opensource.wolfsonmicro.com>
Date: Sat, 21 Apr 2012 00:41:18 +0530
Message-ID: <CAJe_ZhcfcTGjmy-n1hrVjvQ-8+Si4VAWaCf18cpap3NW5b+M=g@mail.gmail.com>
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 April 2012 00:18, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

Going for the closure.
I have a last nail. Don't know whose coffin is it for ;)

>
> In any case, the solution is very clear - just do proper regulator
> support and turn off dummy regulators and everything is fine.
>
You earlier said there are always going to be 'new' platforms that would
need dummy enabled.
Now just imagine if one of those platforms happen to share the consumer
due to which you suggest disabling the dummy (omap_hsmmc in this case).
If we re-enable dummy, then your's isn't really a solution.
If we require that platform to come with full compliance, why can't we
ask every platform to do the same?

Thanks,
-Jassi
