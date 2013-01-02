Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3ABEUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 23:20:34 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:52307 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3ABEUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 23:20:32 -0500
MIME-Version: 1.0
In-Reply-To: <50E3B32A.8070807@lwfinger.net>
References: <50DE378D.4090008@lwfinger.net>
	<CAOh2x==ER3j7P1U+VQEtv00LWWa8JJHu=22--+gTUPFdhiC_cQ@mail.gmail.com>
	<50E3B32A.8070807@lwfinger.net>
Date: Wed, 2 Jan 2013 09:42:37 +0530
Message-ID: <CAKohponf3dCYvEaZAUU4_2zRP+z2nPfskiQmykW4T_TxPG3J+A@mail.gmail.com>
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

On 2 January 2013 09:40, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>> Index: wireless-testing-new/drivers/cpufreq/cpufreq_governor.c
>>
>>
>> How are you creating these patches? wireless-testing-new (linux directory
>> names)
>> aren't supposed to be present here.

You Missed this one?

> I was not adding myself - my name is not Alexander Clouter. When we were
> creating a new module, I got the author from the module that
> cpufreq_governor was originally a part. Perhaps I got the name wrong.

Err.. I read it wrong... sorry :)
