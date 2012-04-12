Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762963Ab2DLW6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:58:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43461 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056Ab2DLW6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:58:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120412.181256.1267592727086214582.davem@davemloft.net>
References: <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
	<CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com>
	<CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com>
	<20120412.181256.1267592727086214582.davem@davemloft.net>
Date: Fri, 13 Apr 2012 01:58:10 +0300
Message-ID: <CAMP44s26eJ6mFHt=C+_AJCkGiDAcMq1O1HsCXPZd5-FRYkZoXQ@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, gregkh@linuxfoundation.org, lists@uece.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless@vger.kernel.org, c_manoha@qca.qualcomm.com,
        ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 1:12 AM, David Miller <davem@davemloft.net> wrote:
> From: Felipe Contreras <felipe.contreras@gmail.com>
> Date: Fri, 13 Apr 2012 01:04:42 +0300
>
>> Wrong is wrong, before or after the 3.3.1 tag, this patch is not
>> 'stable' material, and removing it does not affect upstream at all.
>
> What you don't understand is that bug fixes will get lost if you only
> fix them in -stable, it doesn't matter HOW THEY GOT into -stable.

Let's suppose that c1afdaf was never back-ported from v3.4-rc1, how
would you have fond out there was an issue with it? There's 10000
patches in v3.4-rc2, how do you expect to find issues in them?

People found out this issue on v3.4-rc1, so the fix would not have
been lost, but lets assume it would, v3.3.1 had the issue, the patch
as reverted in v3.3.2, and v3.4 still had the issue. So what? There's
already 10000 patches that would never make it to 3.3.x, and many will
have issues, which is why there would be v3.4.x.

> In fact IT HAS FUCKING HAPPENED that we didn't fix something upstream
> that got fixed in -stable a time long ago when we didn't have the
> policy we're using now which you're going so unreasonably ape-shit
> about.

I see how a *fix* on stable could get lost, but this is not a fix.

A lost fix would be like:

v3.3 (bad), v3.3.1 (good), v3.4 (bad)

But the worst-case scenario here would be:

v3.3 (good), v3.3.1 (bad), v3.3.2 (good), v3.4 (bad)

You said this has happened in the past, I challenge you to find a
single instance of this case: a patch is applied and reverted in
'stable', and the issue triggered by the patches was not fixed in the
next version.

-- 
Felipe Contreras
