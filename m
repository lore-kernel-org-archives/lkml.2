Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab2KGGgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 01:36:13 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62858 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2KGGgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 01:36:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAPub14-CPS48gQ1h8vvAYBpO_=egjheG_rMoZ894Y4XZ2CinUQ@mail.gmail.com>
References: <CAPub14-CPS48gQ1h8vvAYBpO_=egjheG_rMoZ894Y4XZ2CinUQ@mail.gmail.com>
Date: Wed, 7 Nov 2012 12:06:10 +0530
Message-ID: <CAPub148Bq=uwTuky25WzXn4yfCukJ+WacxkBvuyV5yTzGasGOQ@mail.gmail.com>
Subject: Re: possibility of parent clock selection through DT
From: Shiraz Hashim <shiraz.linux.kernel@gmail.com>
To: Mike Turquette <mturquette@ti.com>, Rob Herring <rob.herring@calxeda.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 11:42 AM, Shiraz Hashim
<shiraz.linux.kernel@gmail.com> wrote:
> Hi Mike, Rob,
>
> Devices in a SoC can have multiple possible clock sources which is
> perfectly captured through clk framework.
>
> But the device itself may not be aware of the complex hierarchy above it.
> In this case how do you suggest a board (through DT) should select its
> preference.
>
> Is there some work already going on in this direction ?

Just to make it clear, I already have referred the clock DT bindings and
Shawn Guo patch on removing clk look up registration from kernel code.

Here I am talking about possibility of selecting desired clock hierarchy
by the boards about which device nodes are not aware.

-- 
regards
Shiraz Hashim
