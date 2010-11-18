Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab0KRQ3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:29:19 -0500
Received: from mail.perches.com ([173.55.12.10]:1528 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab0KRQ3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:29:17 -0500
Subject: Re: [PATCH 2/2] drivers: regulator: core: convert to using pr_
 macros
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Walker <dwalker@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        bleong@codeaurora.org
In-Reply-To: <20101118132929.GD7233@rakim.wolfsonmicro.main>
References: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
	 <1290036628-9928-2-git-send-email-dwalker@codeaurora.org>
	 <1290040611.28741.332.camel@Joe-Laptop>
	 <20101118132929.GD7233@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 08:29:15 -0800
Message-ID: <1290097755.1817.13.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 13:29 +0000, Mark Brown wrote:
> On Wed, Nov 17, 2010 at 04:36:51PM -0800, Joe Perches wrote:
> > (rest of original patch below, but no additional comments)
> Don't do that, trim unneeded context from your mails.  This makes it
> much easier to find the actual content you've written and is much nicer
> for those of us who work on mobile connections.

If you check history, you'll find I'm consistent in doing
just that, including trimming blank lines from quoted. 

This was an exceptional case because quoting the original
and declaring "no additional comments" allows Daniel to
see the changes he could make in place.


