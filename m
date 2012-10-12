Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889Ab2JLOrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:47:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42695 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2JLOrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:47:49 -0400
MIME-Version: 1.0
In-Reply-To: <1350052912.10584.167.camel@smile>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
	<91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
	<1350048519.10584.158.camel@smile>
	<CAKohpok=nv2XnFdPkD_yJgUsDqx2gEh=mG_Xhbe-BvT7swVsyg@mail.gmail.com>
	<1350052912.10584.167.camel@smile>
Date: Fri, 12 Oct 2012 20:17:49 +0530
Message-ID: <CAKohpokNE4Pao+tbAFvMC_Yyo-oNvwjbGjV2XKdard4=616e6Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2012 20:11, Shevchenko, Andriy
<andriy.shevchenko@intel.com> wrote:
> On Fri, 2012-10-12 at 19:36 +0530, Viresh Kumar wrote:
> I meant is to use that constant instead of hard coding 4 everywhere.
> It's a maximum value, not the SoC specific.

Can be done.

>> +     u32 val, arr[4];
> what about to use tmp name instead of val? It's really minor, but I
> think val name is little bit unrelated to a loop counter.

Its not minor at all, its major. Even when i was coding it, i thought
about renaming
it several times during this last patch. But couldn't find a better name.

I don't like tmp. Give me something better.

viresh
