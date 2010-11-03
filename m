Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0KCONS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 10:13:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:56394 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab0KCONR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 10:13:17 -0400
Date: Wed, 3 Nov 2010 10:13:15 -0400 (EDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] drivers/hid/hid-input.c: Remove KERN_DEBUG from
 dbg_hid use
In-Reply-To: <b63d550b69fd940f0b03fd7dda8396acb2223801.1288059486.git.joe@perches.com>
Message-ID: <alpine.LNX.2.00.1011031012020.15851@pobox.suse.cz>
References: <cover.1288059486.git.joe@perches.com> <b63d550b69fd940f0b03fd7dda8396acb2223801.1288059486.git.joe@perches.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010, Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/hid/hid-input.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index bb0b365..3a1517a 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -174,7 +174,7 @@ static int hidinput_setkeycode(struct input_dev *dev,
>  
>  		clear_bit(*old_keycode, dev->keybit);
>  		set_bit(usage->code, dev->keybit);
> -		dbg_hid(KERN_DEBUG "Assigned keycode %d to HID usage code %x\n",
> +		dbg_hid("Assigned keycode %d to HID usage code %x\n",
>  			usage->code, usage->hid);
>  
>  		/*

Applied to HID tree, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
