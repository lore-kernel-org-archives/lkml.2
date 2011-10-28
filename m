Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab1J1ONY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 10:13:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41182 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab1J1ONX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 10:13:23 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZgkpn3WZnsSt0fvdBWtMen62Nrat_yAQr3WcA-o8oDuw@mail.gmail.com>
References: <1319796904-799-1-git-send-email-linus.walleij@linaro.org>
 <CA+55aFx8ci-yzPDZDZTqLG4wDx5_t1Od_DRQWJ78PrWU4i5K4Q@mail.gmail.com> <CACRpkdZgkpn3WZnsSt0fvdBWtMen62Nrat_yAQr3WcA-o8oDuw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Oct 2011 07:13:01 -0700
X-Google-Sender-Auth: tCSGJxgRhd8ykWUpBQpf9Kz5gxk
Message-ID: <CA+55aFzjbS8La8GW8x=EKMnLfJ+8=S-Pa8JJRDTcREQMpKBgeg@mail.gmail.com>
Subject: Re: [PATCH] RFC: fs to be compiled with -Dlinux
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 6:50 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>
> Something like this?

Yeah, except that there are other cases that look suspicious too. Line
<drm/drm.h> or <linux/coda.h>.

And <acpi/platform/acenv.h>

There's also tons of them in drivers/scsi/aic7xxx/, and a couple in
drivers/gpu/drm/radeon/radeon_cp.c. The fact that you didn't compile
them seems to be pretty random.

                    Linus
