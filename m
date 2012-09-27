Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2I0GiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:38:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:55027 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab2I0GiK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:38:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,494,1344236400"; 
   d="scan'208";a="197782538"
Message-ID: <1348727884.13371.155.camel@smile>
Subject: Re: [PATCHv2 4/4] MAINTAINERS: add recently created files to
 dw_dmac section
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Date: Thu, 27 Sep 2012 09:38:04 +0300
In-Reply-To: <CAOh2x==ZCozF-Q1rjKapSYKK+x6HdyHs8N2ZJ96iSxoYZKPRXQ@mail.gmail.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348663237-3237-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348663237-3237-5-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x==ZCozF-Q1rjKapSYKK+x6HdyHs8N2ZJ96iSxoYZKPRXQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 20:15 +0530, viresh kumar wrote: 
> On Wed, Sep 26, 2012 at 6:10 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > Append myself to mail subsection as well.
> 
> Mail subsection? You are adding yourself as Maintainer of dw_dmac...
Yes and odd, accordingly to documentation:
"Descriptions of section entries:
...
        M: Mail patches to: FullName <address@domain>
...
        S: Status, one of the following:
...
           Maintained:  Someone actually looks after it.

..."
(subsection = section entry).

The status is applied to the section, but person. We discussed this with
Joe in previous messages.


> Do you really want that.
> I am asking this, because that's not the normal practice followed in kernel.
In current design of the MAINTAINERS database I don't see other way to
apply "watch for the changes to the specific driver" condition.

> This isn't done until unless, somebody has done a MAJOR modification
> to the driver.
Define the "MAJOR" (rhetorical) :-)


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
