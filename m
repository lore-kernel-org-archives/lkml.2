Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab2IXU7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:59:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:8510 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab2IXU7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:59:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,477,1344236400"; 
   d="scan'208";a="212184169"
Date: Mon, 24 Sep 2012 22:59:04 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, arnd@arndb.de
Subject: Re: [PATCH 1/1] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120924205904.GF28670@sortiz-mobl>
References: <1348474306-25155-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdbmDtsb7cxWLeuBKyz0RYDX6uQjnm0uHd_ndY+NKdnHhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbmDtsb7cxWLeuBKyz0RYDX6uQjnm0uHd_ndY+NKdnHhw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Sep 24, 2012 at 10:14:02PM +0200, Linus Walleij wrote:
> On Mon, Sep 24, 2012 at 10:11 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The PRCMU has its own USB, Thermal, GPIO, Modem, HSI and RTC drivers,
> > amongst other things. This patch allows those subordinate devices to
> > use it as an interrupt controller as and when they are DT enabled.
> >
> > CC: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> This is good stuff.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Sam, please pick this up, IRQdomains are a pathway to many
> good things.
Yes, I asked Lee to re-spin this one so that I could pick it up.
Applied and pushed now, thanks guys.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
