Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab3ACL4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 06:56:54 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:58349 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab3ACL4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 06:56:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-dev@lists.linaro.org, nicolas.pitre@linaro.org,
        amit.kucheria@linaro.org, mathieu.poirier@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        pdsw-power-team@arm.com, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] cpufreq: Manage only online cpus
Date: Thu, 03 Jan 2013 13:02:26 +0100
Message-ID: <6008147.vspAd29d9L@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <CAKohponGtLNBnWWX1miV3zjO4pJPumbWoPwoQ2+adCE5t2w5Dw@mail.gmail.com>
References: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org> <7569403.CvHy03LdiU@vostro.rjw.lan> <CAKohponGtLNBnWWX1miV3zjO4pJPumbWoPwoQ2+adCE5t2w5Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 03, 2013 09:02:22 AM Viresh Kumar wrote:
> On 3 January 2013 06:43, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> BTW, i consider them as fixes and so would make sense to get them in next rc.
> >> What do you think?
> >
> > Yes, if somebody tells me "yes, this fixes a problem for me".  Otherwise,
> > I don't quite see the reason.
> 
> I don't know how much people test HOTPLUG, but there are clear bugs related
> to hotplug of cpus on a multiple cpu system :)

True, but have those bugs been introduced recently (ie. in v3.8-rc1 or later)?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
