Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1CVPMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:12:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51731 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754341Ab1CVPMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:12:50 -0400
Date: Tue, 22 Mar 2011 15:12:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: andy.green@linaro.org, Andy Green <andy@warmcat.com>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        roger.quadros@nokia.com, greg@kroah.com, benh@kernel.crashing.org,
        grant.likely@secretlab.ca, Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110322151248.GC22583@opensource.wolfsonmicro.com>
References: <4D79F068.2080009@linaro.org>
 <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 08:32:28PM +0530, Jaswinder Singh wrote:

> It's a different matter that DT has many hearts to win(at least in ARM
> Linux)
> So, perhaps the answer to Q(a) is - Yes.

It's not really a question of hearts to win.  Even for people who are
fully won over the implementation just isn't there in mainline and it's
not clear when it'll be delivered.  Right now device tree can only be
used on SPARC, PowerPC and (I beleive) some x86 platforms.
