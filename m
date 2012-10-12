Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630Ab2JLOza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:55:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52981 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758952Ab2JLOz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:55:28 -0400
MIME-Version: 1.0
In-Reply-To: <20121012145027.GF12801@game.jcrosoft.org>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350051925.git.viresh.kumar@linaro.org>
	<9688d98010716880c1bbd966ead312c446282204.1350051925.git.viresh.kumar@linaro.org>
	<20121012145027.GF12801@game.jcrosoft.org>
Date: Fri, 12 Oct 2012 20:25:27 +0530
Message-ID: <CAKohpomvCkzSuP1GLBXmDTRCHeKXDgGwwXQ+TzU=Jekmozzo=A@mail.gmail.com>
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

On 12 October 2012 20:20, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
> On 20:01 Fri 12 Oct     , Viresh Kumar wrote:
>> dw_dmac driver already supports device tree but it used to have its platform
>> data passed the non-DT way.
>>
>> This patch does following changes:
>> - pass platform data via DT, non-DT way still takes precedence if both are used.
> why keep it  all platform are DT

I would love to remove that, but not sure if somebody want's the non-DT
way too.

I didn't wanted to get into fixing user SoCs of this driver.

--
viresh
