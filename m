Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695Ab1CXS41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:56:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64942 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328Ab1CXS4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:56:25 -0400
Date: Thu, 24 Mar 2011 12:56:20 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jaswinder Singh <jaswinder.singh@linaro.org>, andy.green@linaro.org,
        Andy Green <andy@warmcat.com>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        roger.quadros@nokia.com, greg@kroah.com, benh@kernel.crashing.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110324185620.GA15807@ponder.secretlab.ca>
References: <4D79F068.2080009@linaro.org>
 <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
 <20110322151248.GC22583@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322151248.GC22583@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 03:12:48PM +0000, Mark Brown wrote:
> On Tue, Mar 22, 2011 at 08:32:28PM +0530, Jaswinder Singh wrote:
> 
> > It's a different matter that DT has many hearts to win(at least in ARM
> > Linux)
> > So, perhaps the answer to Q(a) is - Yes.
> 
> It's not really a question of hearts to win.  Even for people who are
> fully won over the implementation just isn't there in mainline and it's
> not clear when it'll be delivered.  Right now device tree can only be
> used on SPARC, PowerPC and (I beleive) some x86 platforms.

MIPS and Microblaze too plus out-of-tree NIOS.

Regardless, I agree 100%.  This isn't (er, shouldn't be) a device tree
debate.  The problem does need to be solved for existing platforms.

g.
