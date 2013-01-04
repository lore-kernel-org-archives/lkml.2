Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab3ADL1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 06:27:22 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59784 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab3ADL1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 06:27:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-dev@lists.linaro.org, nicolas.pitre@linaro.org,
        amit.kucheria@linaro.org, mathieu.poirier@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        pdsw-power-team@arm.com, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] cpufreq: Manage only online cpus
Date: Fri, 04 Jan 2013 12:32:54 +0100
Message-ID: <1908625.BmKqKVnVdj@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <CAKohpo=ok5aH77ycMKPAdHgUkf2HcwMgik+6eZp1Du1QVYxPZQ@mail.gmail.com>
References: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org> <6008147.vspAd29d9L@vostro.rjw.lan> <CAKohpo=ok5aH77ycMKPAdHgUkf2HcwMgik+6eZp1Du1QVYxPZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 04, 2013 10:44:36 AM Viresh Kumar wrote:
> On 3 January 2013 17:32, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > True, but have those bugs been introduced recently (ie. in v3.8-rc1 or later)?
> 
> Don't know... I feel they were always there, its just that nobody
> tested it that way :)

That exactly is my point. :-)

If they have always been there, I don't see much reason for hurrying with the
fixes, so I'll queue them up for v3.9.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
