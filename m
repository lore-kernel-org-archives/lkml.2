Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab0JMHIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 03:08:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34497 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab0JMHIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 03:08:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AeFzn2sEGNS1mrGeZJesPPlDudDTuo+maXvWUEr6Y+mWnzaFRwDvRSPRlA7Yg79BEE
         ykopDFK9M33qc4jNO18A8OB/QcBHVokT4xo1FL5FxrGf2A7nHw6q6b6aBGQ6CdA0tvYT
         k06nuImq1npdiMa4i0tSgH0AAVHc26ywpQdgE=
MIME-Version: 1.0
In-Reply-To: <1286896642-27772-1-git-send-email-ext-andriy.shevchenko@nokia.com>
References: <1286896642-27772-1-git-send-email-ext-andriy.shevchenko@nokia.com>
Date: Wed, 13 Oct 2010 10:08:14 +0300
Message-ID: <AANLkTinvBhcUBQHXRcLeuFW9a0f5xb9G7TzffPP+=7_5@mail.gmail.com>
Subject: Re: [PATCH] mmc: append a file to change host clock at run time
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 6:17 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> For debugging power managment features there is quite convenient to have a
> possibility to change MMC host controller clock at run time. This patch adds
> 'clock' file under MMC host root of debugfs.
>
> Usage as follows:
>
>        # cat /sys/kernel/debug/mmc0/clock
>        24000000
Actually this value should be 52000000 here.

>
>        # echo "1000000000" > /sys/kernel/debug/mmc0/clock
>        # cat /sys/kernel/debug/mmc0/clock
>        52000000
>
>        # echo "48000000" > /sys/kernel/debug/mmc0/clock
>        # cat /sys/kernel/debug/mmc0/clock
>        48000000
>
> The second piece of example shows limits which are applied accordingly to used
> host driver.


-- 
With Best Regards,
Andy Shevchenko
