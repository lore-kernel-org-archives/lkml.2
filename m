Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1BYGwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:52:14 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46273 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab1BYGwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:52:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cePowG/kIkTsLMy+vFwDM9EjGGuJVXd8W2yvKfYFtl6QveWFkZof7EobqfUibK3x/l
         On82OOspR9L0d9qab/cGMxqpFrKy4btXu0qYK0cJYkkqcdX9bOBiFd/kKugRKkjtpKsS
         +Itejhpla02JR7z/CoC9PHGhncD4lFD4yarvc=
MIME-Version: 1.0
In-Reply-To: <1298611140-21573-1-git-send-email-keng-yu.lin@canonical.com>
References: <1298611140-21573-1-git-send-email-keng-yu.lin@canonical.com>
Date: Fri, 25 Feb 2011 07:52:11 +0100
Message-ID: <AANLkTim_JKQU9J3OJ0FRQ_ZVPktAPbnzr2t8SvhL2Uzj@mail.gmail.com>
Subject: Re: [PATCH] eeepc-wmi: set the touchpad toggle key code to F21
From: Corentin Chary <corentin.chary@gmail.com>
To: Keng-Yu Lin <keng-yu.lin@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        tyson.chen@canonical.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 6:19 AM, Keng-Yu Lin <keng-yu.lin@canonical.com> wrote:
> Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
> ---
>  drivers/platform/x86/eeepc-wmi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> https://bugs.freedesktop.org/show_bug.cgi?id=31333
>
> diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
> index d399775..da00cbc 100644
> --- a/drivers/platform/x86/eeepc-wmi.c
> +++ b/drivers/platform/x86/eeepc-wmi.c
> @@ -113,7 +113,7 @@ static const struct key_entry eeepc_wmi_keymap[] = {
>        { KE_KEY, 0x32, { KEY_MUTE } },
>        { KE_KEY, 0x5c, { KEY_F15 } }, /* Power Gear key */
>        { KE_KEY, 0x5d, { KEY_WLAN } },
> -       { KE_KEY, 0x6b, { KEY_F13 } }, /* Disable Touchpad */
> +       { KE_KEY, 0x6b, { KEY_F21 } }, /* Disable Touchpad */
>        { KE_KEY, 0x82, { KEY_CAMERA } },
>        { KE_KEY, 0x83, { KEY_CAMERA_ZOOMIN } },
>        { KE_KEY, 0x88, { KEY_WLAN } },

Hum, I'm not very comfortable with this patch now that we got
KEY_TOUCHPAD_TOGGLE.
I know, it doesn't work with current Xorg, but if we continue to
workaround that, it'll never be fixed.

Dmitry, Matthew, any advice ?
-- 
Corentin Chary
http://xf.iksaif.net
