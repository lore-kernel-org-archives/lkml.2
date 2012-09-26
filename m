Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab2IZOx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:53:26 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62389 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab2IZOxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:53:25 -0400
MIME-Version: 1.0
In-Reply-To: <1348663237-3237-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 26 Sep 2012 20:23:24 +0530
X-Google-Sender-Auth: 0DbPt_6JTQL7UXOcwkUDKbzIJ5Q
Message-ID: <CAOh2x=kPAKXXo7C6meHvy4g0Vpwsx98dMbA6568pmt978eVq6w@mail.gmail.com>
Subject: Re: [PATCHv2 3/4] dma: move dw_dmac driver to an own directory
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 6:10 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The dw_dmac driver contains multiple files. To make a managment of them more
> convenient move it to an own directory.

git format-patch has a option -C or -M or both... that makes such
changes easier to review.
If you create patches with these options, we will not get such long
patches for renames....
instead a single line will tell "foo.c file is renamed as dw/foo.c"

So this patch will have only few lines after that.

Please resend with that... as its impossible to review it currently.

--
viresh
