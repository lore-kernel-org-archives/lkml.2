Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab2JTDqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 23:46:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:38405 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2JTDqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 23:46:50 -0400
Date: Sat, 20 Oct 2012 06:46:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] gpio-timberdale: fix a potential wrapping issue
Message-ID: <20121020034639.GU5685@mwanda>
References: <20121011065635.GD31607@elgon.mountain>
 <CACRpkdZ0EfjMi8i9_bFYwscQVPCPGUFiJwv_FCTMfLbWwsUKZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ0EfjMi8i9_bFYwscQVPCPGUFiJwv_FCTMfLbWwsUKZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 11:01:08PM +0200, Linus Walleij wrote:
> On Thu, Oct 11, 2012 at 8:56 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > ->last_ier is an unsigned long but the high bits can't be used int the
> > original code because the shift wraps.
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Applied, thanks!
> Should we send this to stable? (I assume so ...)

This was a static checker fix.  I guess the answer would depend on
if there are over 30 IRQs.

regards,
dan carpenter

