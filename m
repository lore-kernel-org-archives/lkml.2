Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3ABEEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 23:04:48 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:61903 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3ABEEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 23:04:45 -0500
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jan 2013 23:04:45 EST
MIME-Version: 1.0
In-Reply-To: <50DE378D.4090008@lwfinger.net>
References: <50DE378D.4090008@lwfinger.net>
Date: Wed, 2 Jan 2013 09:26:29 +0530
X-Google-Sender-Auth: 8ZgPlB7r1PTwg-IHDubLuBpYep4
Message-ID: <CAOh2x==ER3j7P1U+VQEtv00LWWa8JJHu=22--+gTUPFdhiC_cQ@mail.gmail.com>
Subject: Re: [PATCH V2] Fix problem with cpufreq_ondemand or cpufreq_conservative
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know, V4 is already accepted, but i had an small comment with one
of your earlier change, which doesn't exist anymore :)

On Sat, Dec 29, 2012 at 5:51 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Index: wireless-testing-new/drivers/cpufreq/cpufreq_governor.c

How are you creating these patches? wireless-testing-new (linux directory names)
aren't supposed to be present here.

> ===================================================================
> --- wireless-testing-new.orig/drivers/cpufreq/cpufreq_governor.c
> +++ wireless-testing-new/drivers/cpufreq/cpufreq_governor.c
> @@ -316,3 +316,8 @@ second_time:
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(cpufreq_governor_dbs);
> +
> +MODULE_AUTHOR("Alexander Clouter <alex@digriz.org.uk>");

You shouldn't be adding yourself as author here :)

MODULE_AUTHOR("Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>");
MODULE_AUTHOR("Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>");
