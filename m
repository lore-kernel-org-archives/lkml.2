Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab2KSHRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 02:17:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21874 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab2KSHRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 02:17:53 -0500
Date: Mon, 19 Nov 2012 10:17:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johan Meiring <johanmeiring@gmail.com>
Cc: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: wlags49_h2: wl_if.h: fixes several coding
 style issues
Message-ID: <20121119071732.GD6135@mwanda>
References: <1353084883-8860-1-git-send-email-johanmeiring@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353084883-8860-1-git-send-email-johanmeiring@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 06:54:43PM +0200, Johan Meiring wrote:
> This commit sorts out several coding style issues, including the use of C99 // comments, spaces at the start of lines, spaces before tabs, incorrect brace placement, and macros with complex values that have not been wrapped in parentheses.  The only remaining issue is the use of typedefs in two instances, but that's something that the original author might need to have a look at.
> 

Could you line wrap your commit message at something like 72-73
characters?  I think that's they rule on email, but I forget.

Normally we ask that people break these kinds of changes into
multiple patches.
[patch 1/x] Staging: wlags49_h2: wl_if.h: use tab indents
[patch 2/x] Staging: wlags49_h2: wl_if.h: fix comment style
etc...

> +/*
> +#define HCF_MIN_COMM_QUALITY        0
> +#define HCF_MAX_COMM_QUALITY        92
> +#define HCF_MIN_SIGNAL_LEVEL        47
> +#define HCF_MAX_SIGNAL_LEVEL        138
> +#define HCF_MIN_NOISE_LEVEL         47
> +#define HCF_MAX_NOISE_LEVEL         138
> +#define HCF_0DBM_OFFSET             149
> +*/

Just delete this dead code.

> +#define SIOCSIWNETNAME              (SIOCDEVPRIVATE+1)
> +#define SIOCGIWNETNAME              (SIOCDEVPRIVATE+2)
> +#define SIOCSIWSTANAME              (SIOCDEVPRIVATE+3)
> +#define SIOCGIWSTANAME              (SIOCDEVPRIVATE+4)
> +#define SIOCSIWPORTTYPE             (SIOCDEVPRIVATE+5)
> +#define SIOCGIWPORTTYPE             (SIOCDEVPRIVATE+6)

Could you put spaces around the '+' operator?
#define SIOCSIWNETNAME		(SIOCDEVPRIVATE + 1)

regards,
dan carpenter

