Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880Ab2EVQBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 12:01:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48690 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724Ab2EVQBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 12:01:38 -0400
MIME-Version: 1.0
In-Reply-To: <1337613303-12463-1-git-send-email-jlee@suse.com>
References: <1337613303-12463-1-git-send-email-jlee@suse.com>
Date: Tue, 22 May 2012 12:01:37 -0400
Message-ID: <CADnq5_M7sSMhMM8ASJ-VOCdZBEx3yo3+P29WgwHRZ-Ls3zHoEA@mail.gmail.com>
Subject: Re: [PATCH] gpu: schedule gma500 stub driver for feature removal
From: Alex Deucher <alexdeucher@gmail.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: dri-devel@lists.freedesktop.org, "Lee, Chun-Yi" <jlee@suse.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:15 AM, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> In v3.3, the gma500 drm driver moved from staging to drm group by
> Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
> brightness well and don't need gma500 stub driver anymore.
>
> So, my plan is remove gma500 stub driver at Dec. 2012.


December 2013?

Alex

>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  Documentation/feature-removal-schedule.txt |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index a0ffac0..219d6f1 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -524,3 +524,14 @@ Files:     arch/arm/mach-at91/at91cap9.c
>  Why:   The code is not actively maintained and platforms are now hard to find.
>  Who:   Nicolas Ferre <nicolas.ferre@atmel.com>
>        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> +
> +----------------------------
> +
> +What:  Intel GMA500 Stub Driver
> +When:  December 2012
> +Why:   In v3.3, the gma500 drm driver moved from staging to drm group by
> +       Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
> +       brightness well and don't need gma500 stub driver anymore.
> +
> +       So, my plan is remove gma500 stub driver at Dec. 2012.
> +Who:   Lee, Chun-Yi <jlee@novell.com>
> --
> 1.6.0.2
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
