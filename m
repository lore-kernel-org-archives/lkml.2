Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab3AJIFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:05:37 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:56604 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635Ab3AJIFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:05:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130110075422.GA11458@S2101-09.ap.freescale.net>
References: <aa10abe640afed8700abf262dbfc9b9c22659b6a.1357729671.git.viresh.kumar@linaro.org>
	<20130110075422.GA11458@S2101-09.ap.freescale.net>
Date: Thu, 10 Jan 2013 13:35:35 +0530
Message-ID: <CAKohpone-pXUjuDsP7r73mP+rzSUUb1oWiu5c+NL8R_WsYoJZg@mail.gmail.com>
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
> On Wed, Jan 09, 2013 at 04:50:44PM +0530, Viresh Kumar wrote:
>> @Shawn: I believe your driver don't require that ugly code anymore (Though i
>> know there is a situation for that to happen, if we have two cpus, you remove
>> second one and then add it back. With this cpufreq_add_dev() would call init()
>> first and then try to match if there are any managed_policies present. But the
>> issue you pointed out about unregistering the driver would be solved by this
>> patch.)
>
> Yes, just played it and it works for me.  However, I would have to keep
> that little ugly code in my patch to save the dependency on your patch.
> Will send a follow-up to clean that up once your patch hits mainline.

Another thing, can i have a tested-by from you for both my patches ? remove and
add dev?

That would help it go quicker.
