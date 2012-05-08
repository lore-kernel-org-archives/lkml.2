Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab2EHQaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:30:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47805 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab2EHQaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:30:08 -0400
MIME-Version: 1.0
In-Reply-To: <4FA9496D.604@xenotime.net>
References: <20120508181531.072fdc5fefa60d852e784587@canb.auug.org.au>
	<4FA9496D.604@xenotime.net>
Date: Tue, 8 May 2012 17:30:07 +0100
Message-ID: <CAPM=9tyNwWw+RfJ7e+XFTjQpN+xABB5ZJ0AqH5W8zfJ_L4e8-w@mail.gmail.com>
Subject: Re: linux-next: Tree for May 8 (gpu/drm/gma500)
From: Dave Airlie <airlied@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Alan Cox <alan@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Alan.

On Tue, May 8, 2012 at 5:27 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 05/08/2012 01:15 AM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> There will be no linux-next tomorrow.
>>
>> Changes since 20120507:
>
>
>
> When CONFIG_ACPI is not enabled:
>
> drivers/gpu/drm/gma500/opregion.c:269:3: error: implicit declaration of function 'register_acpi_notifier'
> drivers/gpu/drm/gma500/opregion.c:288:3: error: implicit declaration of function 'unregister_acpi_notifier'
>
> --
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
