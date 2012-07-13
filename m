Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030433Ab2GMKy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:54:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34167 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030283Ab2GMKyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:54:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120712160415.473748fd.akpm@linux-foundation.org>
References: <1342100468-19426-1-git-send-email-amit.kachhap@linaro.org>
	<1342100468-19426-2-git-send-email-amit.kachhap@linaro.org>
	<20120712160415.473748fd.akpm@linux-foundation.org>
Date: Fri, 13 Jul 2012 16:24:54 +0530
Message-ID: <CADGdYn7MQmv7zHvdRH2eyj2HEx9K87R4H3eJQMX3356A-vZ1kg@mail.gmail.com>
Subject: Re: [linux-pm] [RESEND PATCH v4 1/5] thermal: add generic cpufreq
 cooling implementation
From: amit kachhap <amit.kachhap@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        linux-samsung-soc@vger.kernel.org, SangWook Ju <sw.ju@samsung.com>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-acpi@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        linux-pm@lists.linux-foundation.org,
        Donggeun Kim <dg77.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 4:34 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 12 Jul 2012 19:11:04 +0530
> Amit Daniel Kachhap <amit.kachhap@linaro.org> wrote:
>
>> [akpm@linux-foundation.org: fix comment layout]
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
>> Cc: Donggeun Kim <dg77.kim@samsung.com>
>> Cc: Guenter Roeck <guenter.roeck@ericsson.com>
>> Cc: SangWook Ju <sw.ju@samsung.com>
>> Cc: Durgadoss <durgadoss.r@intel.com>
>> Cc: Len Brown <lenb@kernel.org>
>> Cc: Jean Delvare <khali@linux-fr.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> Something strange appears to have happened here?  At a guess it seems
> that the patches were in my tree, I sent them to someone (Len?), then
> they were merged into linux-next by "someone" and then they fell
> out of linux-next again?
>
> If so, they will hopefully come back soon.  If not, something failed
> fairly seriously.

Hi Andrew,

Yes you are right that this patches first came into your tree and then
Len applied into his next tree for 3.5 merge. so they got into
linux-next tree. After some last minute pull issues they could not be
merged in 3.5 and Len dropped this series from his -next branch. I
hope to get it accepted in 3.6 merge.
I am aware that some work is going on for thermal framework
improvement but that will have minimal changes on cpufreq cooling APIs
and I hope to fix them as bug fix patches.

>
>
> I took a look at re-merging these patches into my tree, but there are
> significant conflicts with other work which has gone into linux-next.
>
Its my fault that I didn't check the hwmon-next branch. I will repost
them after merging with hwmon-next branch.

Thanks,
Amit Daniel
