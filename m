Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1LYKHC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 05:07:02 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38920 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab1LYKHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 05:07:00 -0500
MIME-Version: 1.0
In-Reply-To: <1324744926-24793-1-git-send-email-alecmn@gmail.com>
References: <1324744926-24793-1-git-send-email-alecmn@gmail.com>
Date: Sun, 25 Dec 2011 11:06:58 +0100
Message-ID: <CANq1E4Qab2sO2QagwmU-66+kUWhpStxVWawEGX=1HCdrM7bgLA@mail.gmail.com>
Subject: Re: [PATCH 1/1] hid_wiimote: add INPUT_FF_MEMLESS dependency
From: David Herrmann <dh.herrmann@googlemail.com>
To: Alec Moskvin <alecmn@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alec

On Sat, Dec 24, 2011 at 5:42 PM, Alec Moskvin <alecmn@gmail.com> wrote:
> This fixes build error:
> ...
> CRC 17a7c33e
> Kernel: arch/x86/boot/bzImage is ready  (#1)
>  Building modules, stage 2.
>  MODPOST 7 modules
> ERROR: "input_ff_create_memless" [drivers/hid/hid-wiimote.ko]
> undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
>
> Signed-off-by: Alec Moskvin <alecmn@gmail.com>
> ---
>  drivers/hid/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 22a4a05..332c22a 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -620,6 +620,7 @@ config HID_WIIMOTE
>        depends on BT_HIDP
>        depends on LEDS_CLASS
>        select POWER_SUPPLY
> +       select INPUT_FF_MEMLESS
>        ---help---
>        Support for the Nintendo Wii Remote bluetooth device.
>

This fix is already in Jiri's tree. See here:
http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commitdiff;h=ef6f41157f3864d9bf42671b2ed66062dcafb72e

Regards
David
