Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2LEP7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:59:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58447 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab2LEP7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:59:02 -0500
Date: Wed, 5 Dec 2012 16:59:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andreas Mohr <andi@lisas.de>,
        linux-kernel@vger.kernel.org, Li Shaohua <shaohua.li@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: Look Ma, da kernel is b0rken
Message-ID: <20121205155900.GB28556@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
	Li Shaohua <shaohua.li@intel.com>, linux-acpi@vger.kernel.org
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
 <20121205142935.GA12119@liondog.tnic>
 <20121205152756.5afec12c@pyramind.ukuu.org.uk>
 <20121205153121.GA28556@liondog.tnic>
 <20121205154749.2af4ef36@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121205154749.2af4ef36@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 03:47:49PM +0000, Alan Cox wrote:
> > Hillarious!
> > 
> > Andrew, would you please pick up Alan's patch? It clearly fixes an
> > ancient bug in the pnpacpi code.
> 
> And yes btw we should turn this option on in -next, and get these sort of
> things out of the tree for good. More importantly it'll mean anyone
> adding another one gets a whine on the spot.

Right,

when we added W=, we thought that one use case would be for devs to
use it when build-testing patches and check whether they're adding new
warnings.

However, (1) we need additional functionality in some script to be able
to test when the build log adds new warnings

and

(2) need someone to enforce it.

I think Geert is doing something like that but I'm not sure he's even
using W=.

Actually, it would be cool if something checked for new warnings, mapped
it back to the patch in linux-next adding that warning and then nags the
patch author endlessly until it is fixed.

Thanks.

-- 
Regards/Gruss,
    Boris.
