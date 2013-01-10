Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab3AJIAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:00:00 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38760 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564Ab3AJH76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 02:59:58 -0500
MIME-Version: 1.0
In-Reply-To: <20130110075422.GA11458@S2101-09.ap.freescale.net>
References: <aa10abe640afed8700abf262dbfc9b9c22659b6a.1357729671.git.viresh.kumar@linaro.org>
	<20130110075422.GA11458@S2101-09.ap.freescale.net>
Date: Thu, 10 Jan 2013 13:29:57 +0530
Message-ID: <CAKohpokJRPd2uHLuQDqJnbXwFJDn8sFOu1yRem8m2HuHTu9CyQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Simplify __cpufreq_remove_dev()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: rjw@sisk.pl, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, linaro-dev@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 January 2013 13:24, Shawn Guo <shawn.guo@linaro.org> wrote:
> Yes, just played it and it works for me.  However, I would have to keep
> that little ugly code in my patch to save the dependency on your patch.
> Will send a follow-up to clean that up once your patch hits mainline.

Good. Hopefully, patches from both of us would hit 3.9 and Rafael can
apply yours after mine, with this check removed :)

--
viresh
