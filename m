Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab1LATfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:35:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:35792 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab1LATfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:35:19 -0500
Subject: Re: Different behaviour when using "nosmp" parameter on SMP and UP
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <CAL8zT=jgZS2=t0SadUXXshabKPsxHJe_frkfOw5XyF88k3jR=g@mail.gmail.com>
Date: Thu, 1 Dec 2011 13:35:12 -0600
Cc: Tabi Timur-B04825 <B04825@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
Content-Transfer-Encoding: 7bit
Message-Id: <40F38A2B-48A0-4A8C-B45D-579865F135CC@kernel.crashing.org>
References: <CAL8zT=juU_PC92R4za31R8Lmur0PrFwog1m1fk+PEarW_0C6ng@mail.gmail.com> <D70E8CC4-9FA3-4DC9-B623-02F32EFBFE0F@kernel.crashing.org> <CAL8zT=gGfBYsLcsKobJPhfhEhNeLcrYMoWh2kv0odT0n0wnZgQ@mail.gmail.com> <CAOZdJXVq_g=GAJLRsHZ+290cAJfpOx0LX3sBL3T5i0CaG+xh9Q@mail.gmail.com> <CAL8zT=hK2rDDC7s+SkvCA=C5LjVX+5oRQmP+KQet2mkFEnaKKw@mail.gmail.com> <CAL8zT=jgZS2=t0SadUXXshabKPsxHJe_frkfOw5XyF88k3jR=g@mail.gmail.com>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 1, 2011, at 11:52 AM, Jean-Michel Hautbois wrote:

> 2011/12/1 Jean-Michel Hautbois <jhautbois@gmail.com>:
>> 2011/12/1 Tabi Timur-B04825 <B04825@freescale.com>:
>>> On Thu, Dec 1, 2011 at 9:04 AM, Jean-Michel Hautbois
>>> <jhautbois@gmail.com> wrote:
>>>> 
>>>> Any idea on how to debug this ? I am using a 2.6.35 kernel.
>>> 
>>> There are a ton of Kconfig options for debugging various locking bugs.
>>>  Try turning them on.
>>> 
> 
> All Kconfig options do not help me with cache coherency problems, though.
> Or, I didn't find any option related.
> Any idea ?
> 
> JM

Nope, if you can't describe the code in any more detail we can't help.

- k
