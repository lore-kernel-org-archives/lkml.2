Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2FMMuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:50:16 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43198 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987Ab2FMMuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:50:14 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.97.133]
In-Reply-To: <1339591666.8980.26.camel@twins>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	<1339502524-10265-4-git-send-email-vincent.guittot@linaro.org>
	<CAORVsuWqWt0pJfewymh_ydAH61-uPsO0M7m7Gs4N3zJY=Vo9ZA@mail.gmail.com>
	<CAKfTPtBc-KuDg_1qe04TfYS4+66qQoiHCJQbCF9gnhga5ociow@mail.gmail.com>
	<CAP245DXEOGLe1jq2Wj0rNW5qea63UyJu2jOvwV65Y4B9LLoQtg@mail.gmail.com>
	<1339591666.8980.26.camel@twins>
Date: Wed, 13 Jun 2012 14:50:13 +0200
Message-ID: <CAORVsuXBOHrhx=AFVgdC01=1YFfBgCDpwBH_cn7LBujLfc0rcg@mail.gmail.com>
Subject: Re: [RFC 3/4] ARM: topology: Update cpu_power according to DT information
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Amit Kucheria <amit.kucheria@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux@arm.linux.org.uk,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, linaro-dev@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit, Peter,

On Wed, Jun 13, 2012 at 2:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-06-13 at 18:14 +0530, Amit Kucheria wrote:
>> Various discussions around power-aware scheduling have amplified the
>> need for the scheduler to have some knowledge of DVFS. This would then
>> require the scheduler to track 'cpu_power' ( = max power) and perhaps
>> a new variable 'current_power' that is changed by the DVFS framework.
>
> Note that capacity is in fact a better term -- not to be confused with
> the capacity as currently in use within the load-balancer. Luckily
> there's no way to read that an not be confused.. uhmm :-)
>>
>> The first goal, though, is to make sure that the scheduler can handle
>> different cpu_power values due to asymmetric cores.
>
> I would think the very first goal was to do a simple packing balancer
> before doing silly things with asymmetric setups.. but what do I know.
Sure! First things first ;p

Thanks for the details!

Regards,
Jean
