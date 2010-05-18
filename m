Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab0ERIlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:41:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:34291 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab0ERIlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:41:42 -0400
Date: Tue, 18 May 2010 10:41:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Don Prince <dhprince.devel@yahoo.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.34-rc7] HID: remove redundant key mappings from
 Desktop Wireless 6000
In-Reply-To: <4BF1967D.3060404@yahoo.co.uk>
Message-ID: <alpine.LNX.2.00.1005181041240.28092@pobox.suse.cz>
References: <4BF1967D.3060404@yahoo.co.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010, Don Prince wrote:

> Remove 7 redundant key mappings from Desktop Wireless 6000 that are
> already handled by the default hid code.
> 
> Signed-off-by: Don Prince <dhprince-devel@yahoo.co.uk>
> 
> ---
> 
> Spotted by by Robert Schedel <r.schedel@yahoo.de>
> 
> 
> diff -X /opt/scripts/diff-exclude.txt -Npaur a/drivers/hid/hid-samsung.c b/drivers/hid/hid-samsung.c
> --- a/drivers/hid/hid-samsung.c	2010-05-17 11:01:26.772377750 +0100
> +++ b/drivers/hid/hid-samsung.c	2010-05-17 20:04:36.988502775 +0100
> @@ -112,13 +112,6 @@ static int samsung_kbd_mouse_input_mappi
>  
>  	switch (usage->hid & HID_USAGE) {
>  	/* report 2 */
> -	case 0x0b5: samsung_kbd_mouse_map_key_clear(KEY_NEXTSONG); break;
> -	case 0x0b6: samsung_kbd_mouse_map_key_clear(KEY_PREVIOUSSONG); break;
> -	case 0x0b7: samsung_kbd_mouse_map_key_clear(KEY_STOPCD); break;
> -	case 0x0cd: samsung_kbd_mouse_map_key_clear(KEY_PLAYPAUSE); break;
> -	case 0x0e2: samsung_kbd_mouse_map_key_clear(KEY_MUTE); break;
> -	case 0x0e9: samsung_kbd_mouse_map_key_clear(KEY_VOLUMEUP); break;
> -	case 0x0ea: samsung_kbd_mouse_map_key_clear(KEY_VOLUMEDOWN); break;

Applied, thanks for spotting it Robert.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
