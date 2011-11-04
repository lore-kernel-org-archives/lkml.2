Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab1KDUV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 16:21:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44368 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1KDUV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 16:21:27 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20111027090847.GC6641@opensource.wolfsonmicro.com>
References: <1319702185-16108-1-git-send-email-rnayak@ti.com>
	<20111027090847.GC6641@opensource.wolfsonmicro.com>
Date: Fri, 4 Nov 2011 13:21:26 -0700
Message-ID: <CAOesGMii8v3DOCjWpuF3=+EVu+-HYGys=7RRgpk+9U=FxTHwOA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Device tree support for regulators
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rajendra Nayak <rnayak@ti.com>, patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 2:08 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Oct 27, 2011 at 01:26:21PM +0530, Rajendra Nayak wrote:
>
>> v3 is based on the latest devicetree/next and is tested
>> (with twl adaptaions, which will be posted seperately)
>> on the OMAP4 panda and OMAP4 sdp boards.
>
> Looking at the device bindings I notice that these bindings loose the
> ability to assign a descriptive name to regulator outputs.  This is
> really useful for making it easy to tie the code and the schematics
> together - you can make the runing system use the same name as the
> schematic.

That can easily be added by having a output-name property in the
regulator device node.

-Olof
