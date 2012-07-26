Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2GZXKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 19:10:25 -0400
Received: from mail20.dotsterhost.com ([66.11.232.73]:52841 "EHLO
	mail20.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2GZXKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 19:10:24 -0400
Date: Thu, 26 Jul 2012 16:10:22 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org
Subject: Re: [GIT PULL 00/15] arm-soc: changes for v3.6
Message-ID: <20120726231022.GC20413@animalcreek.com>
References: <1343075561-17446-1-git-send-email-arnd@arndb.de>
 <CA+55aFyObNFgsaVOsjVOcH+aLjDyOgcqpvckM29T3dvugekVwg@mail.gmail.com>
 <201207240751.39111.arnd@arndb.de>
 <alpine.DEB.2.00.1207241436570.10781@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1207241436570.10781@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 02:51:35PM -0600, Paul Walmsley wrote:
> Hi
> 
> On Tue, 24 Jul 2012, Arnd Bergmann wrote:
> 
> > On Tuesday 24 July 2012, Linus Torvalds wrote:
> > 
> > > In your "for-linus" branch, "&mpu_3xxx_clkdm" remains in the
> > > clockdomains_common[] array. In my merge, it is gone. But I think I
> > > did the merge correctly, and you did it wrong. HOWEVER, I don't know
> > > the code, maybe there is some subtle reason why you did it like you
> > > did.
> > 
> > Yes, I think you are right now that I look at it again. Paul Walmsley
> > can have another look at the merge and send an update if we are both
> > missing something now.
> 
> Linus' merge is correct.

FWIW, it looks right to me too.

Thanks,

Mark
