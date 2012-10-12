Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039Ab2JLROy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:14:54 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42224 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab2JLROw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:14:52 -0400
MIME-Version: 1.0
In-Reply-To: <20121012162057.GG12801@game.jcrosoft.org>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350051925.git.viresh.kumar@linaro.org>
	<9688d98010716880c1bbd966ead312c446282204.1350051925.git.viresh.kumar@linaro.org>
	<20121012145027.GF12801@game.jcrosoft.org>
	<CAKohpomvCkzSuP1GLBXmDTRCHeKXDgGwwXQ+TzU=Jekmozzo=A@mail.gmail.com>
	<20121012162057.GG12801@game.jcrosoft.org>
Date: Fri, 12 Oct 2012 22:44:52 +0530
Message-ID: <CAKohpokY9PVTVh6nvPdj9+v0iLeuCOWMmpgaEDqSqNBxqf13WQ@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: vinod.koul@intel.com, devicetree-discuss@lists.ozlabs.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2012 21:50, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
>> >> - pass platform data via DT, non-DT way still takes precedence if both are used.
>> > why keep it  all platform are DT
>>
>> I would love to remove that, but not sure if somebody want's the non-DT
>> way too.
>>
>> I didn't wanted to get into fixing user SoCs of this driver.
> no drop it at the mailine if do not need it

But what's the harm in keeping it until we are sure, all users of it have
moved into DT? It is not adding any overhead for DT case. And this
is what most of the drivers today are doing, because not every platform
is DT compatible.

This driver is used in multiple architectures, not only ARM.

--
viresh
