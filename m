Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab1FWRQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:16:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36021 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab1FWRQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:16:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XL8ZYgNHZZfEX7VGU89/zbWPUFDt6RrruH4lMzYEFjUl6XKZsJOpoeOK8lE6Z1rYQ3
         98rmsxilKdDxsptyYlxrbkUP4vp62CHyadjNd65St7/43EmQoRvUodM6H5jLgzif3y+K
         B6mogXVQHwrVg7EqfkRSnCoCd6mBnl7Y5rSno=
Subject: Re: [PATCH 3/3]drivers:ata:sata_dwc_460ex.c Fix typo
 corrresponding.
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1308810560-23742-3-git-send-email-justinmattock@gmail.com>
References: <1308810560-23742-1-git-send-email-justinmattock@gmail.com>
	 <1308810560-23742-3-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 20:15:41 +0300
Message-ID: <1308849341.27125.18.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 23:29 -0700, Justin P. Mattock wrote: 
> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> The patch below fixes a typo.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/ata/sata_dwc_460ex.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
> index 1c4b3aa..dc88a39 100644
> --- a/drivers/ata/sata_dwc_460ex.c
> +++ b/drivers/ata/sata_dwc_460ex.c
> @@ -389,7 +389,7 @@ static void sata_dwc_tf_dump(struct ata_taskfile *tf)
>  /*
>   * Function: get_burst_length_encode
>   * arguments: datalength: length in bytes of data
> - * returns value to be programmed in register corrresponding to data length
> + * returns value to be programmed in register corresponding to data length
>   * This value is effectively the log(base 2) of the length
>   */
>  static  int get_burst_length_encode(int datalength)

Two other patches are OK.

Acked-by: Vitaliy Ivanov <vitalivanov@gmail.com> 

