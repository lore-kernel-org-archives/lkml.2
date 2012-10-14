Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab2JNQQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 12:16:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44386 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab2JNQQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 12:16:43 -0400
Message-ID: <507AE567.7040701@gmail.com>
Date: Sun, 14 Oct 2012 18:16:39 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>,
        linux ARM <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Common clock framework for external clock generators
References: <4FAB15DB.5050702@googlemail.com> <5076847A.3010705@gmail.com> <5076ED22.3060803@gmail.com> <50785EBF.3060508@gmail.com> <507A9AF6.4030008@gmail.com> <507A9E72.2030800@gmail.com>
In-Reply-To: <507A9E72.2030800@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2012 01:13 PM, Daniel Mack wrote:
> I think the sub-node style above it nicer because it allows referencing
> the individual clocks outputs with a phandle. We use this chip to
> generate base-frequencies for audio clocks, and so we have to switch
> between two freqs for the multiples of 22.5KHz and 24KHz at runtime.

Both examples allow you to have a phandle for all individual clock-outputs.
The examples weren't complete but with the sub-node style you'll reference
with e.g. <&clkout0> while the flat one will use <&si5351 0>. I still prefer
the flat-style as it will not allow to have a phandle of plls.

Sebastian

