Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2K1SjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:39:25 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60630 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2K1SjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:39:24 -0500
MIME-Version: 1.0
In-Reply-To: <ed0ae069e49728a4c17f16e1735d8ffd6b1e0060.1354127005.git.viresh.kumar@linaro.org>
References: <ed0ae069e49728a4c17f16e1735d8ffd6b1e0060.1354127005.git.viresh.kumar@linaro.org>
Date: Thu, 29 Nov 2012 00:09:24 +0530
Message-ID: <CAKohpok=VyQhmfNe_qzM5PKpw6BjH4LyKVoau-ppBy9xdNHejg@mail.gmail.com>
Subject: Re: [PATCH V4 1/3] mfd: stmpe: Get rid of irq_invert_polarity
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sameo@linux.intel.com, grant.likely@secretlab.ca,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, lee.jones@linaro.org,
        linus.walleij@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 November 2012 00:05, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Since the very first patch, stmpe core driver is using irq_invert_polarity as
> part of platform data. But, nobody is actually using it in kernel till now.
>
> Also, this is not something part of hardware specs, but is included to cater
> some board mistakes or quirks.
>
> So, better get rid of it. This is earlier discussed here:
>
> https://lkml.org/lkml/2012/11/27/636
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Please ignore this series.. Two issues:
- rebased over an un accepted patch which rearranges header file
- I can improve patch 2/3 a bit.

I will resend it shortlly.
