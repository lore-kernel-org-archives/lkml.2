Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab2HGAto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 20:49:44 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:57595 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756132Ab2HGAtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 20:49:42 -0400
Message-ID: <502065D7.3020704@xenotime.net>
Date: Mon, 06 Aug 2012 17:48:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Christopher Sacchi <chris.sacchi@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: BeFs parser.h support in linux kernel v3.5
References: <CAGh4K3+krr7Zy97VeFm80U3xsidaWwHLWcbKb-WZ4x+3vH4Sug@mail.gmail.com>
In-Reply-To: <CAGh4K3+krr7Zy97VeFm80U3xsidaWwHLWcbKb-WZ4x+3vH4Sug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 05:07 PM, Christopher Sacchi wrote:

> This patch adds a new header, in the to-do list. There are no style issues.
> Here's the patch:
> --
> Signed-off-by: Christopher P. Sacchi <chris.sacchi@gmail.com>
> --- befs.h      2012-07-21 20:58:29.000000000 +0000
> +++ befs.h      2012-08-06 19:52:05.000000000 +0000
> @@ -9,6 +9,7 @@
>  #define _LINUX_BEFS_H
> 
>  #include "befs_fs_types.h"
> +#include "linux-3.5/include/parser.h"
> 
>  /* used in debug.c */
>  #define BEFS_VERSION "0.9.3"
> 
> --


filesystem patches should also go to linux-fsdevel@vger.kernel.org .


from TODO file:
* See if Alexander Viro's option parser made it into the kernel tree. 
	Use that if we can. (include/linux/parser.h)

Yes, the option parser made it into the kernel tree several years ago,
but just adding the header doesn't make befs use the option parser,
so the patch is not enough.  And the header patch should be:

#include <linux/parser.h>



-- 
~Randy
