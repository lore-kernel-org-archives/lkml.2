Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab3AJIK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:10:57 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62325 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab3AJIKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:10:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpone-pXUjuDsP7r73mP+rzSUUb1oWiu5c+NL8R_WsYoJZg@mail.gmail.com>
References: <aa10abe640afed8700abf262dbfc9b9c22659b6a.1357729671.git.viresh.kumar@linaro.org>
	<20130110075422.GA11458@S2101-09.ap.freescale.net>
	<CAKohpone-pXUjuDsP7r73mP+rzSUUb1oWiu5c+NL8R_WsYoJZg@mail.gmail.com>
Date: Thu, 10 Jan 2013 16:10:55 +0800
Message-ID: <CAAQ0ZWTvKcn5qR8_J5hx+qsxHGTJ8rSE41VD6aQhipM6c+CqTA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Simplify __cpufreq_remove_dev()
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, linaro-dev@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 January 2013 16:05, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Another thing, can i have a tested-by from you for both my patches ? remove and
> add dev?
>
For both:

Tested-by: Shawn Guo <shawn.guo@linaro.org>
