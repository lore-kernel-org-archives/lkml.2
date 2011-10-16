Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1JPIFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 04:05:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57954 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1JPIFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 04:05:02 -0400
MIME-Version: 1.0
In-Reply-To: <20111016073649.GA2642@mwesterb-mobl.ger.corp.intel.com>
References: <1318704009-8178-1-git-send-email-mika.westerberg@iki.fi>
 <20111016042328.GC4901@ponder.secretlab.ca> <20111016073649.GA2642@mwesterb-mobl.ger.corp.intel.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 16 Oct 2011 02:04:41 -0600
X-Google-Sender-Auth: jcED2f8VkJwVSesPO8NxmY0eWcM
Message-ID: <CACxGe6sYxXs-s-Vw2TNQCFmLvAdf_7Fd=t_6TzXryHXtQgBSfQ@mail.gmail.com>
Subject: Re: [PATCH] spi/spi-ep93xx: add module.h include
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 1:36 AM, Mika Westerberg <mika.westerberg@iki.fi> wrote:
> On Sat, Oct 15, 2011 at 10:23:28PM -0600, Grant Likely wrote:
>> On Sat, Oct 15, 2011 at 09:40:09PM +0300, Mika Westerberg wrote:
>> > Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
>>
>> Why?  The commit text needs to explain why the patch is required.
>
> How about following then?
>
> From: Mika Westerberg <mika.westerberg@iki.fi>
> Subject: [PATCHv2] spi/spi-ep93xx: add module.h include
>
> Due to module.h cleanup it is not anymore included implicitly. Drivers who
> want to use it need to include it explicitly.

Perfect, thanks.  Applied.

g.

>
> Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
> ---
>  drivers/spi/spi-ep93xx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
> index 1cf6454..11515c5 100644
> --- a/drivers/spi/spi-ep93xx.c
> +++ b/drivers/spi/spi-ep93xx.c
> @@ -24,6 +24,7 @@
>  #include <linux/dmaengine.h>
>  #include <linux/bitops.h>
>  #include <linux/interrupt.h>
> +#include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/workqueue.h>
>  #include <linux/sched.h>
> --
> 1.7.6.3
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
