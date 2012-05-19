Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab2ESASO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:18:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57180 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab2ESASM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:18:12 -0400
Date: Fri, 18 May 2012 17:16:41 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (battery
 tree related)
Message-ID: <20120519001641.GA32057@lizard>
References: <20120507171458.5ce17d20c40856e9440b3e5f@canb.auug.org.au>
 <20120507082637.GH31494@intel.com>
 <20120516161256.b046bcb06148ac6417fd51b5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120516161256.b046bcb06148ac6417fd51b5@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 04:12:56PM +1000, Stephen Rothwell wrote:
[...]
> > diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
> > index 09d19d2..f8eedd8 100644
> > --- a/drivers/power/smb347-charger.c
> > +++ b/drivers/power/smb347-charger.c
> > @@ -11,6 +11,7 @@
> >   * published by the Free Software Foundation.
> >   */
> >  
> > +#include <linux/err.h>
> >  #include <linux/gpio.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> 
> Ping?

Applied, thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
