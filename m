Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab0CaOqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 10:46:42 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57343 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751813Ab0CaOqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 10:46:39 -0400
Date: Wed, 31 Mar 2010 16:46:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bruno Bigras <bigras.bruno@gmail.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: sleep: fixed a brace coding style issue
Message-ID: <20100331144629.GB3449@ucw.cz>
References: <1268196980-5697-1-git-send-email-bigras.bruno@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268196980-5697-1-git-send-email-bigras.bruno@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-03-09 23:56:20, Bruno Bigras wrote:
> Fix a coding style issue.
> 
> Signed-off-by: Bruno Bigras <bigras.bruno@gmail.com>


While I'm not fan of {}s, this is really excessive.

...especially in a code that uses u32 to pass enums, and opencodes
typecasts.

								Pavel
> ---
>  drivers/acpi/sleep.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index 3bde594..fc8343f 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -62,9 +62,9 @@ static int acpi_sleep_prepare(u32 acpi_state)
>  #ifdef CONFIG_ACPI_SLEEP
>  	/* do we have a wakeup address for S2 and S3? */
>  	if (acpi_state == ACPI_STATE_S3) {
> -		if (!acpi_wakeup_address) {
> +		if (!acpi_wakeup_address)
>  			return -EFAULT;
> -		}
> +
>  		acpi_set_firmware_waking_vector(
>  				(acpi_physical_address)acpi_wakeup_address);
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
