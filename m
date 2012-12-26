Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2LZG2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 01:28:45 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:44062 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2LZG2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 01:28:42 -0500
MIME-Version: 1.0
In-Reply-To: <50DA593E.9000707@asianux.com>
References: <50C85644.7020203@asianux.com>
	<50C858AA.8080305@asianux.com>
	<CAJ6Av5OC+2wdfhb2FExv8NM7Hsyu4_1qnCWV22di8_psw4gF4Q@mail.gmail.com>
	<50CA8129.2020206@asianux.com>
	<CAJ6Av5PqZoW7s94J6MfmiN6kLzYZHH5Cv6qBA+xq65aPO0KA7g@mail.gmail.com>
	<50DA593E.9000707@asianux.com>
Date: Wed, 26 Dec 2012 00:28:40 -0600
Message-ID: <CAJ6Av5PkPa_20xUYjd1h71ajZOoDxjw2sGKUrfEjb4SuoFc4bg@mail.gmail.com>
Subject: Re: [Suggestion] drivers/staging/tidspbridge: pr_err and pr_debug for
 uninitialized buffer (name buf not initialized).
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        eballetbo@iseebcn.com
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2012 at 7:56 PM, Chen Gang <gang.chen@asianux.com> wrote:
> 于 2012年12月24日 22:26, Omar Ramirez Luna 写道:
>>>       b: version merging issue:
>>> >         in drivers/staging/tidspbridge/core/_tiomap.h
>>> >         need use "#include <mach-omap2/cm3xxx.h>" instead of "#include <mach-omap2/cm2xxx_3xxx.h>"
>>> >         the macro OMAP3430_CM_AUTOIDLE_PLL has already move from cm2xxx_3xxx.h to cm3xxx.h.
>>> >           (it seems arch/arm/mach-omap2/ is not a suitable place for including, but we have to)
>>> >         if not change, compiling will be failed.
>
>   also please help checking this issue, thanks.

I also sent a patch for this:

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg82565.html

However, I just saw this one which was sent 6 days ago:

https://patchwork.kernel.org/patch/1895081/

The latter includes the new header file, mine just the definitions
needed, any approach is fine by me as they both fix the compile break.

Cheers,

Omar
