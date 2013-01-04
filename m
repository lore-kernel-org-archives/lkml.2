Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3ADFOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 00:14:39 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:34463 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab3ADFOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 00:14:37 -0500
MIME-Version: 1.0
In-Reply-To: <6008147.vspAd29d9L@vostro.rjw.lan>
References: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org>
	<7569403.CvHy03LdiU@vostro.rjw.lan>
	<CAKohponGtLNBnWWX1miV3zjO4pJPumbWoPwoQ2+adCE5t2w5Dw@mail.gmail.com>
	<6008147.vspAd29d9L@vostro.rjw.lan>
Date: Fri, 4 Jan 2013 10:44:36 +0530
Message-ID: <CAKohpo=ok5aH77ycMKPAdHgUkf2HcwMgik+6eZp1Du1QVYxPZQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] cpufreq: Manage only online cpus
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-dev@lists.linaro.org, nicolas.pitre@linaro.org,
        amit.kucheria@linaro.org, mathieu.poirier@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        pdsw-power-team@arm.com, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 January 2013 17:32, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> True, but have those bugs been introduced recently (ie. in v3.8-rc1 or later)?

Don't know... I feel they were always there, its just that nobody
tested it that way :)
