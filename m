Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2LAQtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 11:49:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61725 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2LAQtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 11:49:22 -0500
MIME-Version: 1.0
In-Reply-To: <2dcd7cb4c4022fa24b5328974e4226f5aaf89419.1354199865.git.viresh.kumar@linaro.org>
References: <2dcd7cb4c4022fa24b5328974e4226f5aaf89419.1354199865.git.viresh.kumar@linaro.org>
Date: Sat, 1 Dec 2012 17:49:21 +0100
Message-ID: <CACRpkdY4fLYa2Wi7u-UUqetMZi1zcBZ-7hq07L1HBMc6nxzsUw@mail.gmail.com>
Subject: Re: [PATCH V5 1/2] mfd: stmpe: Get rid of irq_invert_polarity
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, lee.jones@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 3:40 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

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
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
