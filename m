Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab1EZAKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 20:10:40 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:47686 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754397Ab1EZAKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 20:10:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Q6RyeyPsmBaXwIbjACvWDJ1+L0+fg771/2kZci8Iippj/i08C6cve+c3isoDljnWyV1xeGQw4hXabNNN6lGA6uzJG6iJDsQQ/aXNCrk8UQIfXp/5+8b87eXJWppF0vv7;
Date: Wed, 25 May 2011 17:10:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Dave Jones <davej@redhat.com>, akpm <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Anatolij Gustschin <agust@denx.de>
Subject: Re: fix missing udelay include in mb862xx-i2c
Message-Id: <20110525171036.5e1aecc7.rdunlap@xenotime.net>
In-Reply-To: <20110526000655.GB21913@redhat.com>
References: <20110526000655.GB21913@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 20:06:55 -0400 Dave Jones wrote:

> drivers/video/mb862xx/mb862xx-i2c.c: In function ‘mb862xx_i2c_wait_event’:
> drivers/video/mb862xx/mb862xx-i2c.c:25:3: error: implicit declaration of function ‘udelay’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/drivers/video/mb862xx/mb862xx-i2c.c b/drivers/video/mb862xx/mb862xx-i2c.c
> index cb77d3b..87c79ee 100644
> --- a/drivers/video/mb862xx/mb862xx-i2c.c
> +++ b/drivers/video/mb862xx/mb862xx-i2c.c
> @@ -12,6 +12,7 @@
>  #include <linux/fb.h>
>  #include <linux/i2c.h>
>  #include <linux/io.h>
> +#include <asm/delay.h>
>  
>  #include "mb862xxfb.h"
>  #include "mb862xx_reg.h"


<linux/delay.h>

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
