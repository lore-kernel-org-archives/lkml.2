Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab2LNPjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:39:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51313 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab2LNPjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:39:46 -0500
Date: Fri, 14 Dec 2012 16:39:43 +0100
From: Paolo Pisati <paolo.pisati@canonical.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Paolo Pisati <paolo.pisati@canonical.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Robert Nelson <robertcnelson@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] regulator: core: if voltage scaling fails, restore
 original voltage values
Message-ID: <20121214153943.GA3306@luxor.wired.org>
References: <1355389980-5532-1-git-send-email-paolo.pisati@canonical.com>
 <1355389980-5532-2-git-send-email-paolo.pisati@canonical.com>
 <20121213094715.GA1916@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213094715.GA1916@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 11:47:15AM +0200, Felipe Balbi wrote:
> On Thu, Dec 13, 2012 at 10:13:00AM +0100, Paolo Pisati wrote:
> > Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
> > Tested-by: Robert Nelson <robertcnelson@gmail.com>
> 
> please read Documentation/stable_kernel_rules.txt, you'll see this is
> wrong.

you mean that i should have waited for the commit to hit Linus's tree before
cc-ing stable?

-- 
bye,
p.
