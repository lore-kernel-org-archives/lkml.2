Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab1FPJod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:44:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51225 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab1FPJob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:44:31 -0400
MIME-Version: 1.0
In-Reply-To: <20110616085547.GH4935@const.famille.thibault.fr>
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
	<20110616085547.GH4935@const.famille.thibault.fr>
Date: Thu, 16 Jun 2011 11:44:30 +0200
Message-ID: <BANLkTinxz1T7uPAS0u=gth3hAh+SFQkTQQ@mail.gmail.com>
Subject: Re: [RFC] Add Arm cpu topology definition
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2011 10:55, Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> Hello,
>
> Vincent Guittot, le Thu 16 Jun 2011 10:49:13 +0200, a écrit :
>> The affinity between Arm processors is defined in the MPIDR register.
>> We can identify which processors are in the same cluster,
>> and which ones have performance interdependency. The cpu topology
>>  of an Arm platform can be set thanks to this register and this topology
>> is then used by sched_mc and sched_smt.
>
> Cool!  Could you check that the hwloc tool gets also gets this
> information from userland through /sys, and/or send me the output of the
> hwloc-gather-topology tool from hwloc so we can add an testcase for
> this?
>

The output of hwloc-gather-topology is :

Machine (phys=0 local=280840KB total=280840KB)
  Socket #0 (phys=3)
    Core #0 (phys=0)
      PU #0 (phys=0)
    Core #1 (phys=1)
      PU #1 (phys=1)
depth 0:        1 Machine (type #1)
 depth 1:       1 Socket (type #3)
  depth 2:      2 Cores (type #5)
   depth 3:     2 PUs (type #6)
Topology not from this system

let me know if it's what you want

> Samuel
>
