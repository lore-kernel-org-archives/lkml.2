Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0IIFwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 01:52:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48544 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0IIFv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 01:51:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G/L3mhfInnepAlRQVqbfMxfGy+B3WjBM0aINZ5mnm4goDdwLnMzIntjFy417uRLMYE
         n6LL2lRC2gaFOSNIwBfp8FVv3czqWMNKuZ5XW22c9Nw5JdXzEYQ1h19sEKWa2nZ71axn
         6+6tZ/aeVhgUJqs9IYLroGQsjjy470brVKqM4=
MIME-Version: 1.0
In-Reply-To: <20100909035951.GA3945@kroah.com>
References: <09f59cd98b59bf521a5866ab58c216e0a0347a6c.1283862780.git.ext-andriy.shevchenko@nokia.com>
	<ba5173c9b420d9554c83965f47d0b5cba642743a.1283862780.git.ext-andriy.shevchenko@nokia.com>
	<d7cf4d98c6e0396da903c2e49b028f240853bfc2.1283862780.git.ext-andriy.shevchenko@nokia.com>
	<20100907152753.4726c076.akpm@linux-foundation.org>
	<20100907225843.GA26240@void.printf.net>
	<20100909035951.GA3945@kroah.com>
Date: Thu, 9 Sep 2010 08:51:58 +0300
Message-ID: <AANLkTin-RiDEnKWh_9xT-ssNhgX94mRkx5+gHxoNv_uU@mail.gmail.com>
Subject: Re: [PATCHv6 3/3] mmc_test: collect data and show it via sysfs by demand
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hunter Adrian <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 6:59 AM, Greg KH <greg@kroah.com> wrote:
> Why is this in sysfs at all anyway?
I don't know. The author of module should be asked.

> Why not put it in debugfs?
I thought about this. I even have somewhere a draft patch.

> And for every sysfs file, you need to have a Documenation/ABI/ entry.
>
> Remember, sysfs is "one value per file".  Does that work with this file?
> At first glance, it doesn't look like it.
>
> Please use debugfs instead.
I guess to optimize a work I may do another patch which shifts from
sysfs to debugfs.

-- 
With Best Regards,
Andy Shevchenko
