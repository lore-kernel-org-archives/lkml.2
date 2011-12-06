Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab1LFJZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:25:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932901Ab1LFJZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:25:00 -0500
Date: Tue, 6 Dec 2011 10:24:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2nd attempt] HID: roccat: Add support for Isku keyboard
In-Reply-To: <1322153184.5540.8.camel@neuromancer.tessier-ashpool>
Message-ID: <alpine.LNX.2.00.1112061023150.18207@pobox.suse.cz>
References: <1322153184.5540.8.camel@neuromancer.tessier-ashpool>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Nov 2011, Stefan Achatz wrote:

> I mailed this patch in exactly identical form on 31.08.11
> but it hasn't been applied and I got no answer whatsoever.
> So that's a reminder if it has just been missed in the
> derangement at that time.
> 
> This patch adds support for Roccat Isku keyboard.
> Userland tools can be found at http://sourceforge.net/projects/roccat

I have now queued the patch.

> +config HID_ROCCAT_ISKU
> +	tristate "Roccat Isku keyboard support"
> +	depends on USB_HID
> +	depends on HID_ROCCAT
> +	---help---
> +	Support for Roccat Isku keyboard.
> +

Seeing the number of ROCCAT device drivers growing, I'd actually like to 
ask you whether it'd be possible to have just one driver (with just one 
Kconfig entry) for all the roccat devices (hid-roccat); this starts 
polluting the Kconfig space a little bit, and we don't want to push users 
to select each and every keyboard indeed. Our usual way is doing this on 
per-vendor basis.

Would you be able to implement this for the next merge window?

Thanks,

-- 
Jiri Kosina
SUSE Labs
