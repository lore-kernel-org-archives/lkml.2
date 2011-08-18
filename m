Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab1HRLLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:11:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38413 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1HRLLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:11:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110818103441.GX16790@intel.com>
References: <e13e177c732ee8ad2d6fe389c9bac21877f60c59.1313400777.git.mika.westerberg@linux.intel.com>
	<CACRpkdZ5oCmRupNn9HjZj534zXJQWD8OpycpMxG4Jhgsvk=kEQ@mail.gmail.com>
	<20110817121914.GW16790@intel.com>
	<20110818103441.GX16790@intel.com>
Date: Thu, 18 Aug 2011 14:11:23 +0300
Message-ID: <CAHp75VfST5UnPXkCprx5_0UG0tCa2BDCJeAVmkdDi7_7BvQq3A@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: add functions to enable/disable aggressive clock gating
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cjb@laptop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 1:34 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> I'll prepare a new series which uses mmc_host_clk_{ungate|gate}().
Mika, do the patches to check host->clock in
(mmc|sdhci)_set_data_timeout() become useless after?
If so, probably you could revert them as well.

-- 
With Best Regards,
Andy Shevchenko
