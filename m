Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab1EZVPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:15:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58977 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab1EZVPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CF3P6WdRlAttQWUeqAI5umlGb6V41AReKme9MZHMwI77uyz0939/ZRaGUfeerdqs8w
         4qCmkNlxaAox3NQ9lCuvinoizFMZywBNlLe28niPHoL7Qo48bGCfzasnlJP+ilNk2NIm
         X3ULEUH6VWYVaG9dWPzC6O3Cqtd/mbNLLM9Ak=
MIME-Version: 1.0
In-Reply-To: <1306231448.19557.23.camel@e102109-lin.cambridge.arm.com>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
	<20110523165412.GF15138@n2100.arm.linux.org.uk>
	<1306231448.19557.23.camel@e102109-lin.cambridge.arm.com>
Date: Thu, 26 May 2011 22:15:49 +0100
X-Google-Sender-Auth: 8FcRgzFT1qCz-AeF3JqNuw9sDqU
Message-ID: <BANLkTikjBm3tn4Q4T1r9qyB2ma88YydDZQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/19] ARM: Add support for the Large Physical Address Extensions
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 May 2011 11:04, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Mon, 2011-05-23 at 17:54 +0100, Russell King - ARM Linux wrote:
>> On Sun, May 08, 2011 at 01:51:19PM +0100, Catalin Marinas wrote:
>> > This set of patches adds support for the Large Physical Extensions on
>> > the ARM architecture (available with the Cortex-A15 processor). LPAE
>> > comes with a 3-level page table format (compared to 2-level for the
>> > classic one), allowing up to 40-bit physical address space.
>> >
>> > The ARM LPAE documentation is available from (free registration needed):
>> >
>> > http://infocenter.arm.com/help/topic/com.arm.doc.ddi0406b_virtualization_extns/index.html
>> >
>> > The full set of patches on top of linux-next (LPAE, support for an
>> > emulated Versatile Express with Cortex-A15 tile and generic timers) is
>> > available on this branch:
>> >
>> > git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-2.6-cm.git arm-lpae-next
>>
>> FYI, I'm going to drop the pgt patch because the warnings are still there
>
> What warnings are you seeing? Could you please post them?

Ping?

I'd like to fix those warning but I can't reproduce them (maybe
different compiler versions?).

-- 
Catalin
