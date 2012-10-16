Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab2JPWoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:44:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47201 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab2JPWoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:44:17 -0400
MIME-Version: 1.0
In-Reply-To: <507DBDFF.8030204@xenotime.net>
References: <20121016145856.cfddc9c898c31b1c686804d7@canb.auug.org.au>
	<507DBDFF.8030204@xenotime.net>
Date: Tue, 16 Oct 2012 18:44:15 -0400
Message-ID: <CADnq5_MbMF6OLTYZADVKjrA857JmtHBkJb0xX6WXac4WMyLrvw@mail.gmail.com>
Subject: Re: linux-next: Tree for Oct 16 (readeon_legacy)
From: Alex Deucher <alexdeucher@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 4:05 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 10/15/2012 08:58 PM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> The merge window has closed, feel free to add new stuff again.
>>
>> Changes since 201201015:
>>

patch already sent to Dave:
http://cgit.freedesktop.org/~airlied/linux/commit/?h=drm-fixes&id=cd23492af3d4401c02c48a4bebe5995c9498eac5

Alex

>
>
> on x86_64:
>
> drivers/built-in.o: In function `radeon_asic_init':
> (.text+0xd3c71): undefined reference to `radeon_legacy_set_backlight_level'
> drivers/built-in.o:(.data+0x20490): undefined reference to `radeon_legacy_set_backlight_level'
> drivers/built-in.o:(.data+0x20498): undefined reference to `radeon_legacy_get_backlight_level'
> drivers/built-in.o:(.data+0x20710): undefined reference to `radeon_legacy_set_backlight_level'
> drivers/built-in.o:(.data+0x20718): undefined reference to `radeon_legacy_get_backlight_level'
> drivers/built-in.o:(.data+0x20990): undefined reference to `radeon_legacy_set_backlight_level'
> drivers/built-in.o:(.data+0x20998): undefined reference to `radeon_legacy_get_backlight_level'
> drivers/built-in.o:(.data+0x20c10): undefined reference to `radeon_legacy_set_backlight_level'
> drivers/built-in.o:(.data+0x20c18): undefined reference to `radeon_legacy_get_backlight_level'
> drivers/built-in.o:(.data+0x21110): undefined reference to `radeon_legacy_set_backlight_level'
> drivers/built-in.o:(.data+0x21118): undefined reference to `radeon_legacy_get_backlight_level'
>
>
> Full randconfig file is attached.
> CONFIG_BACKLIGHT_CLASS_DEVICE is not enabled.
>
> --
> ~Randy
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
