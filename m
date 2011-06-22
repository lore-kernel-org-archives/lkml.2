Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab1FVMjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 08:39:41 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52103 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab1FVMjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 08:39:40 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikpasc40ubaHZvJoTVehLWtxvYQqQ@mail.gmail.com>
References: <1308568795-1985-1-git-send-email-vincent.guittot@linaro.org>
	<20110622101423.GB2402@matterhorn1>
	<BANLkTikpasc40ubaHZvJoTVehLWtxvYQqQ@mail.gmail.com>
Date: Wed, 22 Jun 2011 15:39:39 +0300
Message-ID: <BANLkTikQt8dgikHUM5NfYLjWwHgwLbeQrg@mail.gmail.com>
Subject: Re: [RFC PATCH v2] Add ARM cpu topology definition
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 3:20 PM, Vincent Guittot
<vincent.guittot@linaro.org> wrote:
> On 22 June 2011 12:14, Amit Kucheria <amit.kucheria@linaro.org> wrote:
>>> +
>>> +#define topology_physical_package_id(cpu)    (cpu_topology[cpu].socket_id)
>>> +#define topology_core_id(cpu)                (cpu_topology[cpu].core_id)
>>> +#define topology_core_cpumask(cpu)   (&(cpu_topology[cpu].core_sibling))
>>> +#define topology_thread_cpumask(cpu) (&(cpu_topology[cpu].thread_sibling))
>>
>> These #defines are not used anywhere.
>
> They are used in topology.c driver and sched.c
>
>>
>>> +#define mc_capable() (cpu_topology[0].socket_id != -1)
>>> +#define smt_capable()        (cpu_topology[0].thread_id != -1)
>>
>> Neither are these.
>
> They are used in sched.c
>

Ahh, sorry for the noise. Documentation/cputopology.txt is most illuminating.
