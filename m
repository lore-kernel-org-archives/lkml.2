Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab0ESLyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:54:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:52765 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440Ab0ESLx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:53:57 -0400
Date: Wed, 19 May 2010 13:53:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Stephane Chatty <chatty@enac.fr>, wylda@volny.cz,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, Jerome Vidal <jerom3@free.fr>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] HID: Added further information for Roccat Kone
In-Reply-To: <1274199975.2243.0.camel@localhost>
Message-ID: <alpine.LNX.2.00.1005191353230.28092@pobox.suse.cz>
References: <1274199975.2243.0.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Stefan Achatz wrote:

> >From 0875b1fdc784c60d28d3c5bc02ffcf0f30ccea2c Mon Sep 17 00:00:00 2001
> From: Stefan Achatz <erazor_de@users.sourceforge.net>
> Date: Sat, 8 May 2010 16:53:31 +0200
> Subject: [PATCH 2/5] HID: Added further information for Roccat Kone
> 
> Added new data and changed workaround for abnormal button behaviour
> according to new gained knowledge about Roccat Kone device.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  drivers/hid/hid-roccat-kone.c |   11 ++++++-----
>  drivers/hid/hid-roccat-kone.h |   19 ++++++++++++++++---
>  2 files changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
> index d23d309..9d68442 100644
> --- a/drivers/hid/hid-roccat-kone.c
> +++ b/drivers/hid/hid-roccat-kone.c
> @@ -928,14 +928,15 @@ static int kone_raw_event(struct hid_device *hdev, struct hid_report *report,
>  		return 0;
>  
>  	/*
> -	 * Firmware 1.38 introduced new behaviour for tilt buttons.
> -	 * Pressed tilt button is reported in each movement event.
> +	 * Firmware 1.38 introduced new behaviour for tilt and special buttons.
> +	 * Pressed button is reported in each movement event.
>  	 * Workaround sends only one event per press.

Applied, thank you Stefan.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
