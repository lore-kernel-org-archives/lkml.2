Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab3AHVhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:37:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:44163 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab3AHVhj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:37:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="269488362"
Message-ID: <50EC919E.2030404@intel.com>
Date: Tue, 08 Jan 2013 22:37:34 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from platform
 data
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com> <1357555480-24022-6-git-send-email-mika.westerberg@linux.intel.com> <20130108110228.GM4544@opensource.wolfsonmicro.com>
In-Reply-To: <20130108110228.GM4544@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/2013 12:02 PM, Mark Brown wrote:
> On Mon, Jan 07, 2013 at 12:44:34PM +0200, Mika Westerberg wrote:
>> If the architecture doesn't support clk framework (like x86) we need a way to
>> pass the SSP clock rate to the driver. This patch adds a field in the platform
>> data 'fixed_clk_rate' that allows passing the rate.
> No, the way to do this is to fix x86 to enable the clock API there.  The
> x86 maintainers couldn't be bothered when I submitted a patch and
> getting anyone to take a patch to make it available by default appears
> to be unreasonably hard but perhaps if someone from Intel tries the x86
> maintainers might take a patch...

OK

Please explain what you'd like to do.

I haven't seen the original patch.

> We shouldn't be adding special case code to every driver that might need
> a clock that gets used on an Intel system.

I agree with that FWIW.

Thanks,
Rafael

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

