Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2DPTji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:39:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44099 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2DPTjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:39:37 -0400
Message-ID: <4F8C7574.5070109@landley.net>
Date: Mon, 16 Apr 2012 14:39:32 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
CC: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/initrd.txt: Change the location of util-linux
References: <1334200474-28574-1-git-send-email-marcos.souza.org@gmail.com>
In-Reply-To: <1334200474-28574-1-git-send-email-marcos.souza.org@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 10:14 PM, Marcos Paulo de Souza wrote:
> The address of util-linux seems deprecated. The new util-linux location is 
> in the kernel.org. So, change this for the correct address.
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> ---
>  Documentation/initrd.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/initrd.txt b/Documentation/initrd.txt
> index 1ba84f3..3d8bc62 100644
> --- a/Documentation/initrd.txt
> +++ b/Documentation/initrd.txt
> @@ -362,5 +362,5 @@ Resources
>      http://www.almesberger.net/cv/papers/ols2k-9.ps.gz
>  [2] newlib package (experimental), with initrd example
>      http://sources.redhat.com/newlib/
> -[3] Brouwer, Andries; "util-linux: Miscellaneous utilities for Linux"
> -    ftp://ftp.win.tue.nl/pub/linux-local/utils/util-linux/
> +[3] util-linux: Miscellaneous utilities for Linux
> +    http://www.kernel.org/pub/linux/utils/util-linux/

Signed-off-by Rob Landley <rob@landley.net>

I'm tracking this and will put it in the stack I forward to Jiri this
evening.

Thanks,

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
