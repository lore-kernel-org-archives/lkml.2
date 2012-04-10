Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab2DJE1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 00:27:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65483 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2DJE13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 00:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <1334003101-17274-4-git-send-email-robherring2@gmail.com>
References: <1334003101-17274-1-git-send-email-robherring2@gmail.com>
	<1334003101-17274-4-git-send-email-robherring2@gmail.com>
Date: Tue, 10 Apr 2012 01:27:28 -0300
Message-ID: <CAOMZO5AKmnQRo4_3GVDSMUc0fMZ5orwvZSxjXfn6m-5Boew04A@mail.gmail.com>
Subject: Re: [PATCH 3/4] clk: add DT clock binding support
From: Fabio Estevam <festevam@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <kernel@pengutronix.de>, shawn.guo@linaro.org,
        Mike Turquette <mturquette@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 5:25 PM, Rob Herring <robherring2@gmail.com> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
>
> Based on work 1st by Ben Herrenschmidt and Jeremy Kerr, then by Grant
> Likely, this patch adds support to clk_get to allow drivers to retrieve
> clock data from the device tree.
>
> Platforms scan for clocks in DT with of_clk_init and a match table, and
> the register a provider through of_clk_add_provider. The provider's
> clk_src_get function will be called when a device references the
> provider's OF node for a clock reference.
>
> v5 (Rob Herring):
>    - Move from drivers/of into common clock subsystem
>    - Squashed "dt/clock: add a simple provider get function" and
>      "dt/clock: add function to get parent clock name"
>    - Rebase to 3.4-rc1
>    - Drop CONFIG_OF_CLOCK and just use CONFIG_OF
>    - Add missing EXPORT_SYMBOL to various functions
>    - s/clock-output-name/clock-output-names/
>    - Define that fixed-clock binding is a single output

The patch history should go below the --- line,
