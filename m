Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab2CZO3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:29:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61085 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab2CZO3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:29:31 -0400
Message-ID: <4F707D47.9060103@gmail.com>
Date: Mon, 26 Mar 2012 07:29:27 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/5]NEXT:drivers:staging:nvec:nvec.h Fix typos in staging:nvec
References: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

before these get lost in the sands of time; are you wanting to pick 
these up?

On 03/19/2012 08:17 AM, Justin P. Mattock wrote:
> From: "Justin P. Mattock"<justinmattock@gmail.com>
>
> The below patch fixes a typo I found while reading.
>
> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> Cc: Julian Andres Klode<jak@jak-linux.org>
> ---
>   drivers/staging/nvec/nvec.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/nvec/nvec.h b/drivers/staging/nvec/nvec.h
> index a4c17b0..ba6ed8f 100644
> --- a/drivers/staging/nvec/nvec.h
> +++ b/drivers/staging/nvec/nvec.h
> @@ -42,7 +42,7 @@
>    * enum nvec_event_size - The size of an event message
>    * @NVEC_2BYTES: The message has one command byte and one data byte
>    * @NVEC_3BYTES: The message has one command byte and two data bytes
> - * @NVEC_VAR_SIZE: The message has one command byte, one count byte, and as
> + * @NVEC_VAR_SIZE: The message has one command byte, one count byte, and has
>    *                 up to as many bytes as the number in the count byte. The
>    *                 maximum is 32
>    *

