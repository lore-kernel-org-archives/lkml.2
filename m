Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab2JXGHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:07:22 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40902 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836Ab2JXGHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:07:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=Jsy9az4PgJ-mkq_U49EOpHGES+-DaROanCOTn-L2s3Q@mail.gmail.com>
References: <32e5bed743cc6cc4e614291a7080299f5f0d0933.1350677395.git.viresh.kumar@linaro.org>
	<98478a02ae69afc01b3c7860e42a4d763b2045e8.1350677395.git.viresh.kumar@linaro.org>
	<CAKohpo=Jsy9az4PgJ-mkq_U49EOpHGES+-DaROanCOTn-L2s3Q@mail.gmail.com>
Date: Wed, 24 Oct 2012 11:37:13 +0530
Message-ID: <CAKohpomUD-JQbkyEom+_BaRqJSvw8P_hBUsrjTU3vH6bM1+scQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: governors: remove redundant code
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, arvind.chauhan@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2012 14:16, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 20 October 2012 01:42, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> Initially ondemand governor was written and then using its code conservative
>> governor is written. It used a lot of code from ondemand governor, but copy of
>> code was created instead of using the same routines from both governors. Which
>> increased code redundancy, which is difficult to manage.
>>
>> This patch is an attempt to move common part of both the governors to
>> cpufreq_governor.c file to come over above mentioned issues.
>>
>> This shouldn't change anything from functionality point of view.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

For everybody else, this patch is already pushed by Rafael in his linux-next
branch.

--
viresh
