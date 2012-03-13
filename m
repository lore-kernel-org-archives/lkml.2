Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab2CMKwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:52:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52934 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808Ab2CMKwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:52:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAMHCuPUQSPgt8mP2FY7hxi8345ZbLYi9NNbo5P24CDpZp50=_A@mail.gmail.com>
References: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
	<1329905650-30161-3-git-send-email-amit.kachhap@linaro.org>
	<CAMHCuPUOnftKYaGjEpA9rZFc1yjH3U-EkEEUWqcFapSKROTopQ@mail.gmail.com>
	<CAK44p23nZ0kgdieasMkChV8B51Rjt=KrmypN+ksV+nym_e0Cqw@mail.gmail.com>
	<CAMHCuPXSCZjiyW28aPPjO4zF0vgabZUrqtUK5nMXLwNzSWUjQA@mail.gmail.com>
	<CAP245DUqz-N3nG+bc-3b=4YgYk3LMJTWk_wB7Db1ZBm0fBQOSQ@mail.gmail.com>
	<CAMHCuPUQSPgt8mP2FY7hxi8345ZbLYi9NNbo5P24CDpZp50=_A@mail.gmail.com>
Date: Tue, 13 Mar 2012 16:22:09 +0530
Message-ID: <CAK44p224FTbnBXOo34TPgB2dKjT1x-rGbDB+kPitvNhoXy35Tg@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 2/4] thermal: Add generic cpufreq cooling implementation
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Sundar <sunder.svit@gmail.com>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, len.brown@intel.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        mark.gross@intel.com, linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 March 2012 15:44, Sundar <sunder.svit@gmail.com> wrote:
> On Tue, Mar 13, 2012 at 3:30 PM, Amit Kucheria <amit.kucheria@linaro.org> wrote:
>> Sundar,
>
> Hi Amit,
>
>> At the moment it doesn't. But there was some discussion around
>> creating something that will work with devfreq. This would allow
>> peripheral drivers to be plugged in as well. Amit is investigating
>> that at present.
>
> What if we work towards a generic constraint framework which models
> thermals as a performance constraint.
>
> Drivers can register to this constraint; platform code can then decide
> to issue restrictions either to the CPU or other power-hungry
> peripherals based on the platform conditions.
>
> That also allows to model CPU frequency as a generic constraint but
> via an actual consumer, say the thermal driver.

Yes that should be helpful. Even the things your are suggesting are
somewhat same with some patches submitted which sets cpufreq min/max
constraint.

>
> Cheers!
>
> --
> ---------
> The views expressed in this email are personal and do not necessarily
> echo my employers.
