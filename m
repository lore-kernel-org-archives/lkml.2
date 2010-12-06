Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab0LFB0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 20:26:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32810 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0LFB0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 20:26:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TpL/CUlDeccxYZ42Jwuw0n0b6TKzgOnPTWvVvPpENKtjI8DMuLRjrFp3VU77R68G8h
         OYiqGHHU3U6Bqxkm9X0A8tJrbZWBi5xbtMLh1ccJll946LlP0tGpwomOlyDpHdTuFpGI
         RZoKjce824yTQJBxuYX2u1x8bM6Ap290hDWcU=
MIME-Version: 1.0
In-Reply-To: <20100609214616.GA31340@x200>
References: <20100609214616.GA31340@x200>
Date: Sun, 5 Dec 2010 23:26:31 -0200
Message-ID: <AANLkTimDVdQ6-GxMdYHznp1SZp_=_486_Vrun0JEMDw4@mail.gmail.com>
Subject: Re: [PATCH 1/2] kstrto*: converting strings to integers done
 (hopefully) right
From: Thiago Farina <tfransosi@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        yi.y.yang@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 6:46 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> diff --git a/lib/test-kstrtox.c b/lib/test-kstrtox.c
> new file mode 100644
> index 0000000..56fda26
> --- /dev/null
> +++ b/lib/test-kstrtox.c
> @@ -0,0 +1,356 @@
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +#define for_each_test(i, test) \
> +       for (i = 0; i < sizeof(test) / sizeof(test[0]); i++)
> +
micronit: Can you use ARRAY_SIZE macro here? Ignore this if it's irrelevant.
