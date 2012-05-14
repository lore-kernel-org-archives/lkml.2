Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab2ENNkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:40:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34540 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2ENNkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:40:05 -0400
Message-ID: <4FB10B31.7080207@gmail.com>
Date: Mon, 14 May 2012 08:40:01 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/4] clk: add DT clock binding support
References: <1334003101-17274-1-git-send-email-robherring2@gmail.com> <1334003101-17274-4-git-send-email-robherring2@gmail.com> <20120501225900.GC17311@gmail.com>
In-Reply-To: <20120501225900.GC17311@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 05:59 PM, Mike Turquette wrote:
> On 20120409-15:25, Rob Herring wrote:
>> From: Grant Likely <grant.likely@secretlab.ca>
> snip
>> ---
>>  .../devicetree/bindings/clock/clock-bindings.txt   |  117 ++++++++++++++++
>>  .../devicetree/bindings/clock/fixed-clock.txt      |   22 +++
>>  drivers/clk/clk.c                                  |  140 ++++++++++++++++++++
>>  drivers/clk/clkdev.c                               |   77 +++++++++++
>>  include/linux/clk-provider.h                       |   14 ++
>>  include/linux/clk.h                                |   19 +++
>>  6 files changed, 389 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/clock/clock-bindings.txt
>>  create mode 100644 Documentation/devicetree/bindings/clock/fixed-clock.txt
> 
> Hi Rob,
> 
> Patches 1 & 2 are trivial and certainly aimed at clk-next, so I've taken
> them in.  This patch is a bit more difficult as it touches the common
> clk code, clkdev/clk.h and some DT docs.
> 
> Are you looking for me to take this patch into clk-next?  I'm just
> trying to avoid any more clk dependency issues than we already have...
> 

I think that makes the most sense as it appears I'm dependent on
clk-next now. I'm rebasing my patches on clk-next now.

Rob

