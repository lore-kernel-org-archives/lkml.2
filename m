Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0ERMEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 08:04:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:40175 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233Ab0ERMDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 08:03:51 -0400
Date: Tue, 18 May 2010 14:03:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Stephane Chatty <chatty@enac.fr>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Jerome Vidal <jerom3@free.fr>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] HID: Correctly mark init and exit functions of Roccat
 Kone module
In-Reply-To: <1273679065.2927.6.camel@localhost>
Message-ID: <alpine.LNX.2.00.1005181403410.28092@pobox.suse.cz>
References: <1273679065.2927.6.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010, Stefan Achatz wrote:

> >From bbc9f26b13e7756061adb62c561d40f060623bd7 Mon Sep 17 00:00:00 2001
> From: Stefan Achatz <erazor_de@users.sourceforge.net>
> Date: Sat, 8 May 2010 17:20:38 +0200
> Subject: [PATCH 3/5] HID: Correctly mark init and exit functions of
> Roccat Kone module
> 
> Added the __init and __exit hints for module functions.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  drivers/hid/hid-roccat-kone.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-roccat-kone.c
> b/drivers/hid/hid-roccat-kone.c
> index 9d68442..0b1db24 100644
> --- a/drivers/hid/hid-roccat-kone.c
> +++ b/drivers/hid/hid-roccat-kone.c
> @@ -990,12 +990,12 @@ static struct hid_driver kone_driver = {
>  		.raw_event = kone_raw_event
>  };
>  
> -static int kone_init(void)
> +static int __init kone_init(void)
>  {
>  	return hid_register_driver(&kone_driver);
>  }
>  
> -static void kone_exit(void)
> +static void __exit kone_exit(void)
>  {
>  	hid_unregister_driver(&kone_driver);
>  }

Applied, thanks Stefan.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
