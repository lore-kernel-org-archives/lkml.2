Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761103Ab2EJSUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:20:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760793Ab2EJST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:19:59 -0400
Date: Thu, 10 May 2012 11:19:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org
Subject: Re: [PATCH] MAINTAINERS: Add maintainer for LED subsystem
Message-Id: <20120510111958.7cb00da9.akpm@linux-foundation.org>
In-Reply-To: <1336609592-3825-1-git-send-email-bryan.wu@canonical.com>
References: <1336609592-3825-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012 08:26:32 +0800
Bryan Wu <bryan.wu@canonical.com> wrote:

> Add Bryan Wu as the primary maintainer for drivers/leds
> 
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  MAINTAINERS |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7071633..de4e280 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4034,6 +4034,7 @@ F:	Documentation/scsi/53c700.txt
>  F:	drivers/scsi/53c700*
>  
>  LED SUBSYSTEM
> +M:	Bryan Wu <bryan.wu@canonical.com>
>  M:	Richard Purdie <rpurdie@rpsys.net>
>  S:	Maintained
>  F:	drivers/leds/

Please set up a git tree based on Linus mainline, get that tree
included in linux-next (by emailing Stephen) and include its git
URL in this MAINTAINERS record.

Once that is all set up I'll send over the current leds queue -
currently 17 patches.

We don't presently have a leds mailing list.  I generally find stuff by
reading linux-kernel.  You'll now need to do that ;) Even if we did
have a leds mailing list, one would still need to follow lkml to avoid
losing stuff.

Or you can not bother - I read lkml and shall grab stray leds patches and
will send them on to yourself.

