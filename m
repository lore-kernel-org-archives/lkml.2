Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1ASBlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 20:41:35 -0500
Received: from void.printf.net ([89.145.121.20]:55357 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab1ASBld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 20:41:33 -0500
Date: Wed, 19 Jan 2011 01:41:26 +0000
From: Chris Ball <cjb@laptop.org>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: "'Philip Rakity'" <prakity@marvell.com>,
        "'Kyungmin Park'" <kmpark@infradead.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew.chih.howe.khor@intel.com,
        kok.howg.ewe@intel.com,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Subject: Re: A MMC card transfer issue
Message-ID: <20110119014126.GA21707@void.printf.net>
References: <4CD8DE9C.4040505@dsn.okisemi.com> <AANLkTimfnj8GcSwmALjaZUBsiq6ssaVuzVZZsZHRYmiX@mail.gmail.com> <001701cb814c$71926bf0$66f8800a@maildom.okisemi.com> <001201cb90f4$4be8f790$66f8800a@maildom.okisemi.com> <2D50F985-2383-4406-8514-DFE462A5F546@marvell.com> <4D2E0464ABB54FFF9C10583336E27879@hacdom.okisemi.com> <190C6814-8150-491F-AB90-05A93B347246@marvell.com> <A564AB9DDD054732981B672320B7C9B0@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A564AB9DDD054732981B672320B7C9B0@hacdom.okisemi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 10:29:21AM +0900, Tomoya MORINAGA wrote:
> On Wednesday, January 19, 2011 10:00 AM, Philip Rakity wrote:
> > I just looked in the 2.6.37 code and the fix is not there.  
> > It is in the 2.6.37 linus  tree.  
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.g
> > it;a=blob;f=drivers/mmc/core/mmc.c;h=16006ef153fe081c2f0f0a09c
> > d4443ce7f3c49a1;hb=a25cecce88194b2edf38b8c3b1665e9318eb2d22
> 
> Do you know when the above patch will be integrated to kernel ?

I don't understand, sorry.  The link is to a file, not a patch, and
Philip's statement above talks about a patch being in 2.6.37 but not
being in 2.6.37, which I don't understand either.

Looking back farther in the thread, I think you're both talking about:
http://git.kernel.org/?p=linux/kernel/git/cjb/mmc.git;a=commit;h=15ec44611904be0dcc97b84c29fbf964e5e2b36f

This patch was merged into Linus' 2.6.37-rc4 on Nov 27 2010, and
released as part of 2.6.37.

Can you elaborate on your question, if it's still outstanding?

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
