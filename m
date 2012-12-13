Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2LMReL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:34:11 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:50690 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774Ab2LMReI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:34:08 -0500
Date: Thu, 13 Dec 2012 18:34:00 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Cong Ding <dinggnu@gmail.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] drivers/uio/uio_pdrv_genirq.c: Fix memory freeing
 issues
Message-ID: <20121213173400.GH4261@local>
References: <201211271929.32315.vitas@nppfactor.kiev.ua>
 <201212111247.36167.vitas@nppfactor.kiev.ua>
 <20121213171109.GG4261@local>
 <201212131923.21266.vitas@nppfactor.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212131923.21266.vitas@nppfactor.kiev.ua>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 07:23:21PM +0200, Vitalii Demianets wrote:
> On Thursday 13 December 2012 19:11:09 Hans J. Koch wrote:
> > On Tue, Dec 11, 2012 at 12:47:35PM +0200, Vitalii Demianets wrote:
> > > Please, review the v3 of "Fix memory freeing issues" patch (first in the
> > > series I posted yesterday) and ignore the second, as we haven't agreed
> > > on it.
> >
> > I can't find a v3. Please resend it.
> >
> 
> I've posted v3 as a [PATCH 1/2 v3] in series:
> http://www.spinics.net/lists/kernel/msg1450101.html
> 
> You were CC-ed. If for some reason you didn't get it in your mailbox, I'll 
> resend.

OK, found it, sorry. I ignored that one because it does the same flag-testing
stuff. It is unnecessary and only tries to fix userspace stupidity in the
kernel. I won't buy that one, and I already gave an explanation why.
I won't take it just because you disagree with my opinion.

Thanks,
Hans
