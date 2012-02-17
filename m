Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab2BQHdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 02:33:33 -0500
Received: from mail.southpole.se ([193.12.106.18]:60537 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab2BQHda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 02:33:30 -0500
Message-ID: <1329464011.2670.139.camel@crucifix>
Subject: Re: [PATCH] arch/openrisc/include/asm/uaccess.h: included
 linux/thread_info.h twice
From: Jonas Bonn <jonas@southpole.se>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Danny Kukawka <dkukawka@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        linux@openrisc.net, linux-kernel@vger.kernel.org
Date: Fri, 17 Feb 2012 08:33:31 +0100
In-Reply-To: <1329400574-32014-1-git-send-email-danny.kukawka@bisect.de>
References: <1329400574-32014-1-git-send-email-danny.kukawka@bisect.de>
Organization: South Pole AB
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 64006-11300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2012-02-16 at 14:56 +0100, Danny Kukawka wrote:
> arch/openrisc/include/asm/uaccess.h: included 'linux/thread_info.h'
> twice, remove the duplicate.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>


Thanks, applied.
/Jonas


> ---
>  arch/openrisc/include/asm/uaccess.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/openrisc/include/asm/uaccess.h b/arch/openrisc/include/asm/uaccess.h
> index c310e45..f5abaa0 100644
> --- a/arch/openrisc/include/asm/uaccess.h
> +++ b/arch/openrisc/include/asm/uaccess.h
> @@ -26,7 +26,6 @@
>  #include <linux/thread_info.h>
>  #include <linux/prefetch.h>
>  #include <linux/string.h>
> -#include <linux/thread_info.h>
>  #include <asm/page.h>
>  
>  #define VERIFY_READ	0


