Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2CaTSJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 15:18:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42765 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2CaTSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 15:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120331081407.GC15958@gmail.com>
References: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
	<20120331081407.GC15958@gmail.com>
Date: Sat, 31 Mar 2012 12:18:06 -0700
X-Google-Sender-Auth: -oeoA7VukP41ubt6MoCtWOafiCc
Message-ID: <CAE9FiQV-7rnVH1no3wbCJMq0L-FfbAEBh4+XDrnD93X_bK3HvA@mail.gmail.com>
Subject: Re: [PATCH 00/10] vt-d irq_remap_ops patchset
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 1:14 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>
>> Ingo,
>>
>> Here is the Joerg's irq_remap_ops patchset updated for the latest -tip.
>> Simplified some of the naming conventions to follow the irq_remapping
>> terminology. There are still some "if (irq_remapping_enabled)" checks in
>> io_apic.c that I would like to roll into the new io_apic_ops. I will
>> look into that shortly.
>
> Just wondering, has this been tested on affected hardware, on
> top of latest -tip or so? I realize that most of these are
> clean-ups so they should not break anything, but checking would
> be worth it nevertheless.

Yes, I tested those patches on my setups with Nehalem, Westmere, and Sandbridge.

the last two are related to renaming only.

Thanks

Yinghai
