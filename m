Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2ICGVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 02:21:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47651 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab2ICGVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 02:21:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLEb8=sRv91gSZkh9MD4oXatt_iWHPeFMchP4LfJy80ycg@mail.gmail.com>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-13-git-send-email-yinghai@kernel.org>
	<CAOJsxLEb8=sRv91gSZkh9MD4oXatt_iWHPeFMchP4LfJy80ycg@mail.gmail.com>
Date: Sun, 2 Sep 2012 23:21:01 -0700
X-Google-Sender-Auth: Bp_U4m1OmRvFW-S4pD6AR-4p8sg
Message-ID: <CAE9FiQW9-aCEh9ArHKYaTyz+robiZv6dB-VhC5ggecWrH+7ShQ@mail.gmail.com>
Subject: Re: [PATCH -v2 12/13] x86, mm: Use func pointer to table size
 calculation and mapping.
From: Yinghai Lu <yinghai@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 10:43 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Sun, Sep 2, 2012 at 10:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> +static void __init with_all_ram_ranges(
>> +                       void (*work_fn)(unsigned long, unsigned long, void *),
>> +                       void *data)
>
>> +static void __init size_work_fn(unsigned long start, unsigned long end, void *data)
>
>> +static void __init mapping_work_fn(unsigned long start, unsigned long end,
>> +                                        void *data)
>
> So I passionately hate the naming convention. How about something
> similar to mm/pagewalk.c:
>
>   s/with_all_ram_ranges/walk_ram_ranges/g

ok.

>
>   s/size_work_fn/table_space_size/g
>
>   s/mapping_work_fn/map_memory/g

I would prefer simple one size_work_fn, and mapping_working_fn.

Thanks

Yinghai
