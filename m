Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0HITCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:02:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47876 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab0HITCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Qyd7T4eI+NIV3UCBnPOdIWEEyY8S9TxwjQ7BXi4+bn6ZB4JJEcRtl5ZfsiE4qLSCj6
         fdLlFdV1JoJ2rTs52tXmHD5QdWiacX8wPLCmpJbAlSYqumXeQIZpn7YcbdxJ9k7Ivn4Q
         i717zsFMvAzFDVPa2WZC/Hi5Eg89AKDh2CaYk=
MIME-Version: 1.0
In-Reply-To: <1281374816-904-9-git-send-email-ngupta@vflare.org>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	<1281374816-904-9-git-send-email-ngupta@vflare.org>
Date: Mon, 9 Aug 2010 22:02:08 +0300
X-Google-Sender-Auth: D6VTZQABi-c3t_KLssY3ntYSjVE
Message-ID: <AANLkTi=u8m9ETGFx1RMjs+taaXGqaJjh41K7HZBm=kXG@mail.gmail.com>
Subject: Re: [PATCH 08/10] Some cleanups
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>  - xvmalloc: Remove unnecessary stat_{inc,dec} and increment
>   pages_stored directly
>  - xvmalloc: Initialize pointers with NULL instead of 0
>  - zram: Remove verbose message when use sets insane disksize
>  - zram: Mark some messages as pr_debug
>  - zram: Refine some comments
>
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
