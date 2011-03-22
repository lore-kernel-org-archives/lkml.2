Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1CVJek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:34:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:57206 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab1CVJei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:34:38 -0400
Date: Tue, 22 Mar 2011 10:34:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Boyd <bebarino@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/TRIVIAL] HID: Fix typo Keyoutch -> Keytouch
In-Reply-To: <1300786157-29746-1-git-send-email-bebarino@gmail.com>
Message-ID: <alpine.LNX.2.00.1103221034290.19969@pobox.suse.cz>
References: <1300786157-29746-1-git-send-email-bebarino@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Stephen Boyd wrote:

> Signed-off-by: Stephen Boyd <bebarino@gmail.com>
> ---
>  drivers/hid/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index b7ec405..7c28ad9 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -185,7 +185,7 @@ config HID_EZKEY
>  	Support for Ezkey BTC 8193 keyboard.
>  
>  config HID_KEYTOUCH
> -	tristate "Keyoutch HID devices"
> +	tristate "Keytouch HID devices"
>  	depends on USB_HID
>  	---help---
>  	Support for Keytouch HID devices not fully compliant with

Applied to HID tree, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
