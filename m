Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab1JJK0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:26:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:6177 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab1JJK0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:26:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,516,1312182000"; 
   d="scan'208";a="60600314"
Date: Mon, 10 Oct 2011 12:29:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/2] mfd/db8500-prcmu: rename init function
Message-ID: <20111010102917.GK3686@sortiz-mobl>
References: <1317833447-714-1-git-send-email-linus.walleij@stericsson.com>
 <CACRpkdY=u2mmOZSeJRFvBbRyLwkbpKxSzKPx9gu-i8416KK5jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY=u2mmOZSeJRFvBbRyLwkbpKxSzKPx9gu-i8416KK5jQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Oct 05, 2011 at 06:59:01PM +0200, Linus Walleij wrote:
> On Wed, Oct 5, 2011 at 6:50 PM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
> 
> > From: Linus Walleij <linus.walleij@linaro.org>
> >
> > This renames the PRCMU clock force initialization function
> > to have a less generic name.
> 
> So these are fixing the review comments, if you prefer me to squash
> them into the other patches just tell me.
> 
> I can also prepare a pull request for the stuff you want if it makes
> things easier for you, just tell me what you want in it.
I took the first 12 patches plus your 2 review fixes. I indeed feel the rest
of the patchset would need some additional work. If there's really nothing we
can do about factorizing more of this code between 8500 and 5500, then I'll
look at it for the 3.3 merge window.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
