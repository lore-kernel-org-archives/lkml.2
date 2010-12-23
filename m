Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab0LWTNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 14:13:15 -0500
Received: from void.printf.net ([89.145.121.20]:51723 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab0LWTNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 14:13:14 -0500
Date: Thu, 23 Dec 2010 19:13:11 +0000
From: Chris Ball <cjb@laptop.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [GIT PULL] MMC fixes for 2.6.37
Message-ID: <20101223191311.GA9220@void.printf.net>
References: <m3pqss50lr.fsf@pullcord.laptop.org> <AANLkTine-9YC7062cNaPG+iieBD2bcttx2b3sf3sveKP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTine-9YC7062cNaPG+iieBD2bcttx2b3sf3sveKP@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Thu, Dec 23, 2010 at 06:17:50PM +0900, Kyungmin Park wrote:
> Can you include the s5pc210 external clock support?

As I said:

If Ben agrees, I'm happy to send it on.

If Ben stays silent, then I have to overrule him -- he's the maintainer
of this driver.  I'm okay with doing that, but I'd like to do it by
shipping these patches in the next merge window and giving him (and
others who test the -rc series) time to disagree.

> without this, s5pc210 boards doesn't use the SDHCI.

But that's not a regression from earlier kernels (correct me if I'm
wrong).  Adding support for a new board is a merge window task, not
a final-fixes-before-release task.

I'm sorry these patches have been waiting so long.  I didn't realize
Ben would stay silent on them -- in future, I'll shorten my timeout
for an ACK from Ben.

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
