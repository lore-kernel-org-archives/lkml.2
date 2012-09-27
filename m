Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab2I0IE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:04:59 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43756 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2I0IEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:04:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120927074236.GI12592@arwen.pp.htv.fi>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348731121-2515-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<20120927074236.GI12592@arwen.pp.htv.fi>
Date: Thu, 27 Sep 2012 11:04:54 +0300
Message-ID: <CAHp75VcPb2KrxYYv8F27bSszLwHi0BN5VPxmuEXmGtUPziuigQ@mail.gmail.com>
Subject: Re: [PATCHv3 3/7] dmaengine: dw_dmac: remove CLK dependency
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:42 AM, Felipe Balbi <balbi@ti.com> wrote:
>> -     depends on HAVE_CLK
>
> as is, this will break compilation of any arch which doesn't set
> HAVE_CLK.
As Viresh suggested and I checked it's not.
He wrote nice patch that adds stubs for such case.

-- 
With Best Regards,
Andy Shevchenko
