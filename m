Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2DRXsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:48:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51240 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370Ab2DRXs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:48:29 -0400
X-Sasl-enc: eRnudZgfFJVDebkpkvCELMvIkPDSoGU4uricFxvRImwf 1334792908
Date: Wed, 18 Apr 2012 16:48:27 -0700
From: Greg KH <greg@kroah.com>
To: Valentin Ilie <valentin.ilie@gmail.com>
Cc: arve@android.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: binder.c const char* smth TO const
 char * const smth
Message-ID: <20120418234827.GA2227@kroah.com>
References: <1334543494-13425-1-git-send-email-valentin.ilie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334543494-13425-1-git-send-email-valentin.ilie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 05:31:34AM +0300, Valentin Ilie wrote:
> Replaced static const char* var with static const char * var const smth because
> smth doesn't need to be reassigned at any point else at runtime.

"smth"?  What is that?

> 
> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
> ---
>  drivers/staging/android/binder.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index c283212..221bd3f 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -3303,7 +3303,7 @@ static void print_binder_proc(struct seq_file *m,
>  		m->count = start_pos;
>  }
>  
> -static const char *binder_return_strings[] = {
> +static const char * const binder_return_strings[] = {

I don't understand, what's the advantage here?  Why is this needed?
Does it save space?  Speed?  Compiler warnings?

I need a better reason to apply it other than a word with no vowels...

greg k-h
