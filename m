Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1CAOV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:21:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:49893 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab1CAOVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:21:25 -0500
Date: Tue, 1 Mar 2011 15:21:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: mac@melware.de, isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]drivers:isdn:istream.c Fix typo pice to piece
In-Reply-To: <1298269881-2754-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1103011521160.32580@pobox.suse.cz>
References: <1298269881-2754-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Feb 2011, Justin P. Mattock wrote:

> The below patch changes a typo "pice" to "piece"
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/isdn/hardware/eicon/istream.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/isdn/hardware/eicon/istream.c b/drivers/isdn/hardware/eicon/istream.c
> index 18f8798..7bd5baa 100644
> --- a/drivers/isdn/hardware/eicon/istream.c
> +++ b/drivers/isdn/hardware/eicon/istream.c
> @@ -62,7 +62,7 @@ void diva_xdi_provide_istream_info (ADAPTER* a,
>    stream interface.
>    If synchronous service was requested, then function
>    does return amount of data written to stream.
> -  'final' does indicate that pice of data to be written is
> +  'final' does indicate that piece of data to be written is
>    final part of frame (necessary only by structured datatransfer)
>    return  0 if zero lengh packet was written
>    return -1 if stream is full

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
