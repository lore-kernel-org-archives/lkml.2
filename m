Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab0IHJOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:14:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49262 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab0IHJOQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:14:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cg2dGxBLZtKpnvntL/xUu0O3RcbuK9wlBasyqrEt+sIDw1L+sOL8Fs82NiqDLRPkCR
         bVN89b+tXElqH/S78SlQ/C4SRji6Vvi50vGDHNDMa8b0mLJKLe+0e9W+P3yhZHn38ATn
         9uc6q3Uyr04We6Z5KkcG39NGROxJiCNkOUhhQ=
MIME-Version: 1.0
In-Reply-To: <20100907225843.GA26240@void.printf.net>
References: <09f59cd98b59bf521a5866ab58c216e0a0347a6c.1283862780.git.ext-andriy.shevchenko@nokia.com>
	<ba5173c9b420d9554c83965f47d0b5cba642743a.1283862780.git.ext-andriy.shevchenko@nokia.com>
	<d7cf4d98c6e0396da903c2e49b028f240853bfc2.1283862780.git.ext-andriy.shevchenko@nokia.com>
	<20100907152753.4726c076.akpm@linux-foundation.org>
	<20100907225843.GA26240@void.printf.net>
Date: Wed, 8 Sep 2010 12:14:05 +0300
Message-ID: <AANLkTik2Tmi1uKp5k=ri454ZfmxKg-tNOZghOn__NCED@mail.gmail.com>
Subject: Re: [PATCHv6 3/3] mmc_test: collect data and show it via sysfs by demand
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hunter Adrian <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 1:58 AM, Chris Ball <cjb@laptop.org> wrote:
> Hoping Andy doesn't mind me jumping in, here's an attempt at a better
> changelog:
Thanks. I will take into account this.

> Prior to this patch, the "test" file under each card's sysfs node was
> write-only, and results were obtained by looking at dmesg.  This patch
> improves programmatic access to the test results, making them available
> by reading back from the same "test" file:
>
> [root@host mmc0:e624]# echo 6 > test
> [root@host mmc0:e624]# cat test
> Test 6: 2
It even better to get this sample for performance tests as well.

> I think we should do this by modifying the Kconfig text as well:
At least. And add documentation and link to it in Kconfig.

> Separately, Andy, I think we should translate the general result return
> code for the user, i.e. print OK/FAIL/UNSUP_HOST/UNSUP_CARD for return
> values 0-3.  Would you mind adding that?  (Unfortunately, it invalidates
> the usage example I just gave above, so that should change too..)
I thought about it. But for the scripts may be better to keep numeric
value as well.
I will think again hot to implement better.

Thanks.

-- 
With Best Regards,
Andy Shevchenko
