Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2DRPdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:33:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45037 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab2DRPc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:32:58 -0400
MIME-Version: 1.0
In-Reply-To: <1334744560-28985-1-git-send-email-bbergenthal@cern.ch>
References: <1334744560-28985-1-git-send-email-bbergenthal@cern.ch>
From: Daniel Kurtz <djkurtz@google.com>
Date: Wed, 18 Apr 2012 23:32:37 +0800
Message-ID: <CAGS+omB6a+1+3D1ByU-rR6Xe4uWbeswFJip8rPO8UMj0Pg5Cww@mail.gmail.com>
Subject: Re: [PATCH] Driver: HID: hid-apple: Fixed a tab width style issue
To: Benedikt Bergenthal <bbergenthal@cern.ch>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benedikt Bergenthal <benedikt@kdrennert.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 6:22 PM, Benedikt Bergenthal
<bbergenthal@cern.ch> wrote:
>
> From: Benedikt <bbergenthal@cern.ch>
>
> Fixed a style issue.
>
> Signed-off-by: Benedikt Bergenthal <benedikt@kdrennert.de>

Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>

> ---
>  drivers/hid/hid-apple.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
> index 299d238..7a79e39 100644
> --- a/drivers/hid/hid-apple.c
> +++ b/drivers/hid/hid-apple.c
> @@ -234,7 +234,7 @@ static int hidinput_apple_event(struct hid_device
> *hid, struct input_dev *input,
>                }
>        }
>
> -        if (iso_layout) {
> +       if (iso_layout) {
>                if (asc->quirks & APPLE_ISO_KEYBOARD) {
>                        trans = apple_find_translation(apple_iso_keyboard,
> usage->code);
>                        if (trans) {
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Daniel Kurtz | Software Engineer | djkurtz@google.com | 650.204.0722
