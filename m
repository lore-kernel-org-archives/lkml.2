Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab2IDCsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 22:48:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61608 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab2IDCsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 22:48:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXHyS-ybeo5fBQwQzUtK2TTqPVkuf+6heZKrGn1wS77tQ@mail.gmail.com>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-14-git-send-email-yinghai@kernel.org>
	<CAOJsxLFtpBnvtA3F=7NDJunqXRs4AL1=oe7HR6GECgGfr9TqDA@mail.gmail.com>
	<CAE9FiQV9pE0FOgqTbNpUf0s04yCTeHkApvUtzGXKwQw-7XB2KA@mail.gmail.com>
	<CAOJsxLG+o7NwuAfamPzsPJC6K_TRAO_J_W=Nn8yj9bJiqxp=Xg@mail.gmail.com>
	<CAE9FiQXHyS-ybeo5fBQwQzUtK2TTqPVkuf+6heZKrGn1wS77tQ@mail.gmail.com>
Date: Mon, 3 Sep 2012 19:48:15 -0700
X-Google-Sender-Auth: lVYBeVqCGQ-uSGnMZMdxild6CPE
Message-ID: <CAE9FiQVVKnEnFrxm1KDJeq5xgt3BXymhYF4w20qB3Kr2Sn5zUw@mail.gmail.com>
Subject: Re: [PATCH -v2 13/13] x86, 64bit: Map first 1M ram early before memblock_x86_fill()
From: Yinghai Lu <yinghai@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 12:18 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sun, Sep 2, 2012 at 11:26 PM, Pekka Enberg <penberg@kernel.org> wrote:
>>
>> Yup, or move the globals together with the comment to arch/x86/mm/init.c.
>>
>> That said, max_pfn_high_mapped really ought to be kept together with
>> the other "pfn_mapped" globals and the comment should be updated.
>
> max_pfn_high_mapped is only for 64bit, and it is in init_64.c
>
> maybe later could have another patch to move max_pfn_mapped,
> max_low_pfn_mapped from
> kernel/setup.c to mm/init.c
>
> Please check attached updated patch.

oh,  I'm wrong.

this patch is not needed, until some day we could not need to do low
kernel mapping in head_64.S

Thanks

Yinghai
