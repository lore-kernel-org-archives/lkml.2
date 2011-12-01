Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1LARxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:53:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45990 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab1LARxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:53:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAL8zT=hK2rDDC7s+SkvCA=C5LjVX+5oRQmP+KQet2mkFEnaKKw@mail.gmail.com>
References: <CAL8zT=juU_PC92R4za31R8Lmur0PrFwog1m1fk+PEarW_0C6ng@mail.gmail.com>
 <D70E8CC4-9FA3-4DC9-B623-02F32EFBFE0F@kernel.crashing.org>
 <CAL8zT=gGfBYsLcsKobJPhfhEhNeLcrYMoWh2kv0odT0n0wnZgQ@mail.gmail.com>
 <CAOZdJXVq_g=GAJLRsHZ+290cAJfpOx0LX3sBL3T5i0CaG+xh9Q@mail.gmail.com> <CAL8zT=hK2rDDC7s+SkvCA=C5LjVX+5oRQmP+KQet2mkFEnaKKw@mail.gmail.com>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Thu, 1 Dec 2011 18:52:37 +0100
Message-ID: <CAL8zT=jgZS2=t0SadUXXshabKPsxHJe_frkfOw5XyF88k3jR=g@mail.gmail.com>
Subject: Re: Different behaviour when using "nosmp" parameter on SMP and UP
To: Tabi Timur-B04825 <B04825@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/1 Jean-Michel Hautbois <jhautbois@gmail.com>:
> 2011/12/1 Tabi Timur-B04825 <B04825@freescale.com>:
>> On Thu, Dec 1, 2011 at 9:04 AM, Jean-Michel Hautbois
>> <jhautbois@gmail.com> wrote:
>>>
>>> Any idea on how to debug this ? I am using a 2.6.35 kernel.
>>
>> There are a ton of Kconfig options for debugging various locking bugs.
>>  Try turning them on.
>>

All Kconfig options do not help me with cache coherency problems, though.
Or, I didn't find any option related.
Any idea ?

JM
