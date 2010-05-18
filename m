Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab0ERMEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 08:04:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:40249 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757218Ab0ERMEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 08:04:41 -0400
Date: Tue, 18 May 2010 14:04:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Stephane Chatty <chatty@enac.fr>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Jerome Vidal <jerom3@free.fr>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] HID: refactored special event handling in Roccat
 Kone
In-Reply-To: <1273679086.2927.7.camel@localhost>
Message-ID: <alpine.LNX.2.00.1005181404100.28092@pobox.suse.cz>
References: <1273679086.2927.7.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010, Stefan Achatz wrote:

> 
> >From e550163af2c39c4e7490cd5bf02e44c5dec72d2b Mon Sep 17 00:00:00 2001
> From: Stefan Achatz <erazor_de@users.sourceforge.net>
> Date: Sat, 8 May 2010 17:30:27 +0200
> Subject: [PATCH 4/5] HID: refactored special event handling in Roccat
> Kone
> 
> As special events are reported along with hid event information all
> events are now processed further by standard handler.
> Also cleaned up this code.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  drivers/hid/hid-roccat-kone.c |   54
> +++++++++++++++-------------------------
>  1 files changed, 20 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/hid/hid-roccat-kone.c
> b/drivers/hid/hid-roccat-kone.c
> index 0b1db24..66e6940 100644
> --- a/drivers/hid/hid-roccat-kone.c
> +++ b/drivers/hid/hid-roccat-kone.c
> @@ -912,6 +912,24 @@ static void kone_remove(struct hid_device *hdev)
>  	hid_hw_stop(hdev);
>  }
>  
> +/* handle special events and keep actual profile and dpi values up to
> date */

This is also line-wrapped, could you please fix that up in your mail 
client and resend?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
