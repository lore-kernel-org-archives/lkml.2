Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab2EAXDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:03:51 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:54759 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881Ab2EAXDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:03:50 -0400
Date: Tue, 1 May 2012 15:59:00 -0700
From: Mike Turquette <mturquette@ti.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/4] clk: add DT clock binding support
Message-ID: <20120501225900.GC17311@gmail.com>
References: <1334003101-17274-1-git-send-email-robherring2@gmail.com>
 <1334003101-17274-4-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334003101-17274-4-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120409-15:25, Rob Herring wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
snip
> ---
>  .../devicetree/bindings/clock/clock-bindings.txt   |  117 ++++++++++++++++
>  .../devicetree/bindings/clock/fixed-clock.txt      |   22 +++
>  drivers/clk/clk.c                                  |  140 ++++++++++++++++++++
>  drivers/clk/clkdev.c                               |   77 +++++++++++
>  include/linux/clk-provider.h                       |   14 ++
>  include/linux/clk.h                                |   19 +++
>  6 files changed, 389 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/clock-bindings.txt
>  create mode 100644 Documentation/devicetree/bindings/clock/fixed-clock.txt

Hi Rob,

Patches 1 & 2 are trivial and certainly aimed at clk-next, so I've taken
them in.  This patch is a bit more difficult as it touches the common
clk code, clkdev/clk.h and some DT docs.

Are you looking for me to take this patch into clk-next?  I'm just
trying to avoid any more clk dependency issues than we already have...

Thanks,
Mike
