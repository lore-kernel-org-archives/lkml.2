Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1KVUUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:20:21 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:58141 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755547Ab1KVUUT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:20:19 -0500
MIME-Version: 1.0
In-Reply-To: <9315670.oOZAWsuHPb@wuerfel>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <CAPtuhTheG-mvoGMaB2y9BSKF-abm2yigoN-SXaeCb+P5R6t_Dg@mail.gmail.com>
 <CACxGe6vK-vHvSbd9N2k3FZY4gGVS_DETx0BbfPgNghTkOncjpg@mail.gmail.com> <9315670.oOZAWsuHPb@wuerfel>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Tue, 22 Nov 2011 12:19:51 -0800
Message-ID: <CAJOA=zOp3o=bdryFbz6LVQF5fxPvhVWKme_GD3fyQr7=-n2E_g@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] clk: export tree topology and clk data via sysfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-dev@lists.linaro.org, jeremy.kerr@canonical.com,
        Mike Turquette <mturquette@linaro.org>, linus.walleij@stericsson.com,
        sboyd@quicinc.com, broonie@opensource.wolfsonmicro.com,
        magnus.damm@gmail.com, linux-kernel@vger.kernel.org,
        eric.miao@linaro.org, Grant Likely <grant.likely@secretlab.ca>,
        aul@pwsan.com, patches@linaro.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, linux-omap@vger.kernel.org, skannan@quicinc.com,
        linux-arm-kernel@lists.infradead.org, arnd.bergmann@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 12:02 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 22 November 2011 12:19:51 Grant Likely wrote:
>> On Tue, Nov 22, 2011 at 11:01 AM, Mike Turquette <mturquette@linaro.org> wrote:
>>
>> > Others have requested to have knobs made available for actually
>> > performing clk_enable/clk_disable and even clk_set_rate from
>> > userspace.  I hate this idea and won't implement it.  I encourage
>> > anyone that needs this to do it in debugfs.
>> >
>> > Does that work-split make sense to you, or do you still not like the
>> > idea of having topology and read-only info in sysfs?
>>
>> Unless there is a solid real-world use case for exporting this data to
>> userspace, I do not think sysfs is a good idea.  As long as the usage
>> (beyond debug) is theoretical I think the whole thing should be in
>> debugfs.  It can always be moved at a later date If a real use case
>> does become important.
>
> I would recomment not to spend any time on implementing a debugfs interface
> for this right now. As far as I can tell, nothing relies on exporting
> the structure to user space, so Mike's time is better spent on getting the
> other four patches merged.

Seems to be some consensus on this.  Will drop userspace-visible clk
tree from V4 patchset.

Regards,
Mike

>
> Note that the static topology information about clocks will already be
> visible in /proc/devicetree when that is enabled and the clocks are
> described in the .dts file.
>
>        Arnd
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
