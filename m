Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2LLInJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 03:43:09 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:38189 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2LLInE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 03:43:04 -0500
MIME-Version: 1.0
In-Reply-To: <1355301621.31620.66.camel@smile>
References: <3100e691db3f94c22afd98b609a1568d7e70dfe7.1350360935.git.viresh.kumar@linaro.org>
	<169edae67b9a051ca7448e5b62c3cd2c5c1db470.1350360935.git.viresh.kumar@linaro.org>
	<201212102208.52347.arnd@arndb.de>
	<CAKohpo=FjZuMOC-wuNc3q_FXbk546ttCLr55GkW9AL0Tz-HoBA@mail.gmail.com>
	<1355301621.31620.66.camel@smile>
Date: Wed, 12 Dec 2012 14:13:03 +0530
Message-ID: <CAKohpom2h4ZrO_vFVUDOA_KfDmA-PpG1aPDMnufbM9kcUhc_OA@mail.gmail.com>
Subject: Re: [PATCH V3 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 December 2012 14:10, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Will we survive if the patch is in mainline? I mean how big the impact
> of it is?

It doesn't fail to do fulfill its purpose and even ALL DT stuff would work well.
Its just the matter of using the right API's, design and bindings :)
