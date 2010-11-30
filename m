Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab0K3Q6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:58:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:34555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab0K3Q6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:58:35 -0500
Date: Tue, 30 Nov 2010 17:58:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] hid: egalax: Rework to include Joojoo and Wetab
 support
In-Reply-To: <4CF3AD99.9050400@euromail.se>
Message-ID: <alpine.LNX.2.00.1011301758130.23409@pobox.suse.cz>
References: <1291016612-25102-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1011291248290.981@pobox.suse.cz> <4CF3AD99.9050400@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Henrik Rydberg wrote:

> Something like this, perhaps?
> 
> >From c6675000b59412b22f4f798de4268318e39b628c Mon Sep 17 00:00:00 2001
> From: Henrik Rydberg <rydberg@euromail.se>
> Date: Mon, 29 Nov 2010 14:40:11 +0100
> Subject: [PATCH] hid: egalax: Document the newly supported models in Kconfig
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hid/Kconfig |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 3052e29..401acec 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -154,7 +154,8 @@ config HID_EGALAX
>  	tristate "eGalax multi-touch panel"
>  	depends on USB_HID
>  	---help---
> -	Support for the eGalax dual-touch panel.
> +	Support for the eGalax dual-touch panels, including the
> +	Joojoo and Wetab tablets.

Yes, that would be sufficient. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
