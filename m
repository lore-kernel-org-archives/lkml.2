Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2KYKpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 05:45:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47178 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2KYKpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 05:45:44 -0500
MIME-Version: 1.0
In-Reply-To: <1353759165.1420.33.camel@x61.thuisdomein>
References: <1353759165.1420.33.camel@x61.thuisdomein>
Date: Sun, 25 Nov 2012 11:45:43 +0100
Message-ID: <CAFLxGvyfH3WdNpsGzV2OgvyT_8hu4U03+HEuv3u9DvSkOmNBtA@mail.gmail.com>
Subject: Re: [PATCH] ewrk3: silence GCC warning
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 1:12 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Building ewrk3.o triggers this GCC warning:
>     drivers/net/ethernet/dec/ewrk3.c: In function '__check_irq':
>     drivers/net/ethernet/dec/ewrk3.c:1915:1: warning: return from incompatible pointer type [enabled by default]
>
> This can be trivially fixed by changing the 'irq' parameter from int to
> byte (which is the alias for unsigned char for module parameters).
>
> While we're touching this code also drop an outdated comment, that
> should have been dropped with the patch named "MODULE_PARM conversions"
> from early 2005.

Please send this change as an additional patch.

-- 
Thanks,
//richard
