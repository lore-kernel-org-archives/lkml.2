Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab2LaBPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 20:15:39 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54586 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab2LaBPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 20:15:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAHFgRy-GKacNL0Vcp1H1ac0zLEcjp1Y42aAz+jMVCdr=pMBDWg@mail.gmail.com>
References: <CAHFgRy-GKacNL0Vcp1H1ac0zLEcjp1Y42aAz+jMVCdr=pMBDWg@mail.gmail.com>
Date: Mon, 31 Dec 2012 11:15:36 +1000
Message-ID: <CAPM=9txc-OX+gbKTn+6NR4a=VMiYBr9QjoJnf=nFMU2gnjGSoQ@mail.gmail.com>
Subject: Re: Linus GIT (3.8.0-rc1+) -- drivers/built-in.o: In function
 `nouveau_acpi_edid': (.text+0x134e47): undefined reference to `acpi_video_get_edid'
From: Dave Airlie <airlied@gmail.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, skeggsb@gmail.com,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Maarten Maathuis <madman2003@gmail.com>, maximlevitsky@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2012 at 10:41 AM, Miles Lane <miles.lane@gmail.com> wrote:
>   LD      init/built-in.o
> drivers/built-in.o: In function `nouveau_acpi_edid':
> (.text+0x134e47): undefined reference to `acpi_video_get_edid'

Wierd not really sure why this would have just stared happening.
select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE &&
VIDEO_OUTPUT_CONTROL && INPUT

should pick ACPI_VIDEO=y from what I can see if nouveau is y, unless I
misunderstand Kconfig, which is most probable.

Dave.
