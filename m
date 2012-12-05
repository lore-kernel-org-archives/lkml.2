Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2LEPb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:31:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55932 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab2LEPbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:31:24 -0500
Date: Wed, 5 Dec 2012 16:31:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andreas Mohr <andi@lisas.de>,
        linux-kernel@vger.kernel.org, Li Shaohua <shaohua.li@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: Look Ma, da kernel is b0rken
Message-ID: <20121205153121.GA28556@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Andreas Mohr <andi@lisas.de>,
	linux-kernel@vger.kernel.org, Li Shaohua <shaohua.li@intel.com>,
	linux-acpi@vger.kernel.org
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
 <20121205142935.GA12119@liondog.tnic>
 <20121205152756.5afec12c@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121205152756.5afec12c@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 03:27:56PM +0000, Alan Cox wrote:
> On Wed, 5 Dec 2012 15:29:35 +0100
> Borislav Petkov <bp@alien8.de> wrote:
> 
> > On Wed, Dec 05, 2012 at 08:09:01AM +0100, Andreas Mohr wrote:
> > > Hi,
> > > 
> > > drivers/pnp/pnpacpi/core.c: In function 'ispnpidacpi':
> > > drivers/pnp/pnpacpi/core.c:65:2: warning: logical 'or' of collectively
> > > exhaustive tests is always true [-Wlogical-op]
> > > drivers/pnp/pnpacpi/core.c:66:2: warning: logical 'or' of collectively
> > > exhaustive tests is always true [-Wlogical-op]
> > > drivers/pnp/pnpacpi/core.c:67:2: warning: logical 'or' of collectively
> > > exhaustive tests is always true [-Wlogical-op]
> > > 
> > > 
> > > That's already the second less enticing -Wlogical-op issue
> > > which was discovered by accident during less than two days
> 
> No it's not. It's been reported in bugzilla. I sent patches ages ago.
> They were ignored. Coverity has had it tagged for years (and a ton more
> of them you've not noticed yet)
> 
> http://article.gmane.org/gmane.linux.acpi.devel/56753/match=test_alpha
> 
> This isn't discovered, this is in the "If you stick your fingers in your
> ears and hum you can't hear the screaming" category.

Hillarious!

Andrew, would you please pick up Alan's patch? It clearly fixes an
ancient bug in the pnpacpi code.

Thanks.

-- 
Regards/Gruss,
    Boris.
