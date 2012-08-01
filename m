Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2HAQhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:37:11 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65087 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab2HAQhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:37:10 -0400
MIME-Version: 1.0
In-Reply-To: <004201cd6fa3$b0538b70$10faa250$%han@samsung.com>
References: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr>
 <1343752762-16861-6-git-send-email-damien.cassou@lifl.fr> <002c01cd6f73$4252b090$c6f811b0$%han@samsung.com>
 <CAK9yfHzje6NLqi5ixxA3J4aT1a9p6wJNJePzTi4xG9LN6AeLVw@mail.gmail.com> <004201cd6fa3$b0538b70$10faa250$%han@samsung.com>
From: Damien Cassou <damien.cassou@gmail.com>
Date: Wed, 1 Aug 2012 18:36:48 +0200
Message-ID: <CA+y5ggiOuhLk9paN5L0Z8odwM0vAP88fxiFtTjxb-XckHg6Tjg@mail.gmail.com>
Subject: Re: [PATCH 5/5] drivers/video/exynos/exynos_dp_core.c: use devm_ functions
To: Jingoo Han <jg1.han@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, kernel-janitors@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 1, 2012 at 7:08 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> To Damien,
> As Sachin Kamat mentioned, please change the subject more specific. For example,
>
>     video: exynos_dp: use devm_clk_get function

ok, done in a new thread titled:

[PATCH v2] video: exynos_dp: use devm_clk_get function

Thank you for the feedback

-- 
Damien Cassou
http://damiencassou.seasidehosting.st

"Lambdas are relegated to relative obscurity until Java makes them
popular by not having them." James Iry
