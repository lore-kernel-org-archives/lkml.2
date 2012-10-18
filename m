Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab2JRSI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 14:08:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55415 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725Ab2JRSI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 14:08:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=Vfq=z8NK6w4_QpwwLniYiwcfGfzWZsoG_zBPYPXrcUw@mail.gmail.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1350387889-15324-6-git-send-email-hongbo.zhang@linaro.com>
	<CAKohpo=Vfq=z8NK6w4_QpwwLniYiwcfGfzWZsoG_zBPYPXrcUw@mail.gmail.com>
Date: Thu, 18 Oct 2012 23:38:26 +0530
X-Google-Sender-Auth: 3g65jqPY0GYcwwGbmlOH62GqBpI
Message-ID: <CAOh2x=ntPkmYn0CRc+k4fPqU+y2ZMv2_cRE2vAeRM-d_dvm2BA@mail.gmail.com>
Subject: Re: [PATCH 5/5] Thermal: Add ST-Ericsson db8500 thermal dirver.
From: viresh kumar <viresh.kumar@linaro.org>
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 8:53 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 16 October 2012 17:14, hongbo.zhang <hongbo.zhang@linaro.org> wrote:

>> +static int __devinit db8500_cpufreq_cooling_probe(struct platform_device *pdev)
>> +{
>> +       struct db8500_cpufreq_cdev *cooling_devs;

Hi Hongbo,

I saw somebody saying this in another thread:

> > __devinit &__devexit will go away sometime soon, so please don't use it in new
> > code.

commit 45f035a (only in linux-next I think) has some details.

--
viresh
