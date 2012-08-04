Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2HDBeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 21:34:15 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:35256 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752676Ab2HDBeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 21:34:12 -0400
Message-ID: <501C7BC8.5020801@xenotime.net>
Date: Fri, 03 Aug 2012 18:32:56 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH] pstore: fix printk format warning
References: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com> <501C66A8.5000902@xenotime.net> <20120804011531.GA22175@lizard>
In-Reply-To: <20120804011531.GA22175@lizard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 06:15 PM, Anton Vorontsov wrote:

> On Fri, Aug 03, 2012 at 05:02:48PM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> Fix printk format warning (on i386) in pstore:
>>
>> fs/pstore/ram.c:409:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
>>
>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> Acked-by: Kees Cook <keescook@chromium.org>
>> Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
>> ---
>> I posted this patch on June 15 and July 23 but it has not been
>> merged anywhere afaict, so I'm sending it directly to the man.
> 
> (I believe it's the first time I see that patch.)

That's quite possible.  When Kees acked it, he advised
me to send it to GregKH, which I did, to no avail.


> Btw, I see no maintainers for the pstore, and it surely no longer
> belongs to staging. Tony, I can send patches to you, or I can create
> a git tree (actually, I already had it for my own convenience).. So
> how about the following patch?

Thanks for adding a MAINTAINERS entry for it.

> Kees, Colin, as you're also pstore authors, I assume you're interested
> in reviewing/[n]acking any possible changes, so I also added you to
> the M: entries, is that OK?
> 
> - - - -
> From: Anton Vorontsov <cbouatmailru@gmail.com>
> Subject: [PATCH] MAINTAINERS: Add pstore maintainers
> 
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> ---
>  MAINTAINERS |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 94b823f..9aa40c1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5496,6 +5496,18 @@ L:	cbe-oss-dev@lists.ozlabs.org
>  S:	Maintained
>  F:	drivers/block/ps3vram.c
>  
> +PSTORE FILESYSTEM
> +M:	Anton Vorontsov <cbouatmailru@gmail.com>
> +M:	Colin Cross <ccross@android.com>
> +M:	Kees Cook <keescook@chromium.org>
> +M:	Tony Luck <tony.luck@intel.com>
> +S:	Maintained
> +T:	git git://git.infradead.org/users/cbou/linux-pstore.git
> +F:	fs/pstore/
> +F:	include/linux/pstore*
> +F:	drivers/firmware/efivars.c
> +F:	drivers/acpi/apei/erst.c
> +
>  PTP HARDWARE CLOCK SUPPORT
>  M:	Richard Cochran <richardcochran@gmail.com>
>  S:	Maintained



-- 
~Randy
