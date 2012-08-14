Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2HNBbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:31:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:58252 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab2HNBbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:31:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,763,1336374000"; 
   d="scan'208";a="207892186"
Date: Tue, 14 Aug 2012 09:25:52 +0800
From: Feng Tang <feng.tang@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>, <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH RFT 1/2] gpio: gpio-ml-ioh: Use spinlock for register
 access protection
Message-ID: <20120814092552.6e06305d@feng-i7>
In-Reply-To: <CACRpkdaLUCe8_cuYh_pq7HUKkWhaSXS6xEU=ZwbpoUcy9nCz4w@mail.gmail.com>
References: <1343530482.5373.2.camel@phoenix>
	<CACRpkdaLUCe8_cuYh_pq7HUKkWhaSXS6xEU=ZwbpoUcy9nCz4w@mail.gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2012 14:01:31 +0200
Linus Walleij <linus.walleij@linaro.org> wrote:

> On Sun, Jul 29, 2012 at 4:54 AM, Axel Lin <axel.lin@gmail.com> wrote:
> 
> > gpio_chip.can_sleep is 0, but current code uses mutex in ioh_gpio_set,
> > ioh_gpio_get and ioh_gpio_direction_input functions.
> > Thus those functions are not callable from interrupt context.
> > This patch converts mutex into spinlock.
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> So IOH guys what are you saying about this?

I'm not the IOH guy, but just happened to work on it for some time :) Anyway,
the 2 patches both look good to me.

Thanks,
Feng

