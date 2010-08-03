Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0HCDwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 23:52:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41247 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab0HCDwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 23:52:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YdPryC5kxVRAxPO0jnv+NbbFUvMyiIkyiXiIfM0uxDMR3IQsCwYEyS0T7Bnw/zV//5
         QqDjcYdbhButI77gl8/udtvOXaRnDmtLbC9mdZCV1mZmu8DnvhFqQO6Y/GWYQWBy2DB3
         JPVmia+Kxp44cVZ/cDqwaGAOWqfwOCUTQjagM=
MIME-Version: 1.0
In-Reply-To: <1280806670-21009-1-git-send-email-justinmattock@gmail.com>
References: <1280806670-21009-1-git-send-email-justinmattock@gmail.com>
Date: Tue, 3 Aug 2010 13:52:33 +1000
Message-ID: <AANLkTi=cwXv6e5Biud5tFGHOESavFxLg2-4deNZ=pemj@mail.gmail.com>
Subject: Re: [PATCH]drivers/usb/host/ehci-sched.c Fix typo
From: Andrew Hendry <andrew.hendry@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This may have been intended, it means if and only if.
http://en.wikipedia.org/wiki/Iff

On Tue, Aug 3, 2010 at 1:37 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> The below patch fixes a typo in a comment.
>
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  drivers/usb/host/ehci-sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
> index 805ec63..3c170a9 100644
> --- a/drivers/usb/host/ehci-sched.c
> +++ b/drivers/usb/host/ehci-sched.c
> @@ -1662,7 +1662,7 @@ itd_link_urb (
>
>  #define        ISO_ERRS (EHCI_ISOC_BUF_ERR | EHCI_ISOC_BABBLE | EHCI_ISOC_XACTERR)
>
> -/* Process and recycle a completed ITD.  Return true iff its urb completed,
> +/* Process and recycle a completed ITD.  Return true if its urb completed,
>  * and hence its completion callback probably added things to the hardware
>  * schedule.
>  *
> --
> 1.7.1.rc1.21.gf3bd6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
