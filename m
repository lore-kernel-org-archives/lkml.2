Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab2CZQnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:43:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49818 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab2CZQm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:42:58 -0400
Date: Mon, 26 Mar 2012 18:42:50 +0200
From: Julian Andres Klode <jak@jak-linux.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Marc Dietrich <marvin24@gmx.de>
Subject: Re: [PATCH 1/5]NEXT:drivers:staging:nvec:nvec.h Fix typos in
 staging:nvec
Message-ID: <20120326164250.GA21100@jak-linux.org>
References: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 08:17:49AM -0700, Justin P. Mattock wrote:
> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> The below patch fixes a typo I found while reading.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> Cc: Julian Andres Klode <jak@jak-linux.org>

You could have CCed Marc Dietrich <marvin24@gmx.de> as well. He's
also listed in MAINTAINERS.


> ---
>  drivers/staging/nvec/nvec.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/nvec/nvec.h b/drivers/staging/nvec/nvec.h
> index a4c17b0..ba6ed8f 100644
> --- a/drivers/staging/nvec/nvec.h
> +++ b/drivers/staging/nvec/nvec.h
> @@ -42,7 +42,7 @@
>   * enum nvec_event_size - The size of an event message
>   * @NVEC_2BYTES: The message has one command byte and one data byte
>   * @NVEC_3BYTES: The message has one command byte and two data bytes
> - * @NVEC_VAR_SIZE: The message has one command byte, one count byte, and as
> + * @NVEC_VAR_SIZE: The message has one command byte, one count byte, and has
>   *                 up to as many bytes as the number in the count byte. The
>   *                 maximum is 32

We can probably just drop the [h]as as well, right? That sounds a bit
better to me.

-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.
