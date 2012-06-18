Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2FRGPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:15:46 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:58536 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2FRGPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:15:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120617165548.GA4267@opensource.wolfsonmicro.com>
References: <1339122469.5794.2.camel@phoenix>
	<CACRpkdaUVMp+VstcSsWCQ-5Oe8QwcQL5Rt41Xm7kR2parUDgVQ@mail.gmail.com>
	<20120617165548.GA4267@opensource.wolfsonmicro.com>
Date: Mon, 18 Jun 2012 08:15:42 +0200
Message-ID: <CACRpkdYmTRRRf_gMg4R57r7yxgdyFU+LBfWhqqiZ1zFsar3kNw@mail.gmail.com>
Subject: Re: [PATCH RFT 1/2] regulator: ab8500: Use regulator_list_voltage_linear
 for ab8500_regulator_fixed_ops
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 6:55 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Sun, Jun 17, 2012 at 04:24:52PM +0200, Linus Walleij wrote:
>> On Fri, Jun 8, 2012 at 4:27 AM, Axel Lin <axel.lin@gmail.com> wrote:
>
>> > Also removes set_voltage_time_sel callback from ab8500_regulator_fixed_ops
>> > because the voltage won't change. ( And ab8500_regulator_fixed_ops does not
>> > implement get_voltage_sel so set_voltage_time_sel won't be called )
>> >
>> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
>> I cannot test this either, it does not apply cleanly on v3.5-rc3.
>
>> Care to respin?
>
> This is a random development patch which means it'll get applied against
> the regulator tree as it stands so that's what the patch should be
> submitted against - if you're going to test then grabbing my for-next
> branch is the way forward.

I was mostly reacting to the "RFT" keyword in the subject, so I tried to
test rather than just ACK it, but it's applied now anyway so whatever.
Acked-by.

Yours,
Linus Walleij
