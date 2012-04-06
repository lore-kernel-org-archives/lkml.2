Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2DFKdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 06:33:13 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:38231 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753350Ab2DFKdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 06:33:11 -0400
MIME-Version: 1.0
In-Reply-To: <4F7DA009.4010802@linux.intel.com>
References: <1333619620-21201-1-git-send-email-pdeschrijver@nvidia.com> <4F7DA009.4010802@linux.intel.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Fri, 6 Apr 2012 16:02:37 +0530
Message-ID: <CAMQu2gzwe0F3qcaTqASEPUASdG1SjpUxrBrSp-RrYLgy3W24OQ@mail.gmail.com>
Subject: Re: [RFC PATCH] cpuidle: allow per cpu latencies
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Thu, Apr 5, 2012 at 7:07 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 4/5/2012 2:53 AM, Peter De Schrijver wrote:
>> This patch doesn't update all cpuidle device registrations. I will do that
>
> question is if you want to do per cpu latencies, or if you want to have
> both types of C state in one big table, and have each of the tegra cpyu
> types pick half of them...
>
>
Indeed !! That should work.
I thought the C-states are always per CPU based and during the
cpuidle registration you can register C-state accordingly based on the
specific CPU types with different latencies if needed.

Am I missing something ?

Regards
Santosh
