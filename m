Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0IWIjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 04:39:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51999 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751791Ab0IWIjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 04:39:11 -0400
Date: Thu, 23 Sep 2010 09:39:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: linux-next: build failure after merge of the sound tree
Message-ID: <20100923083931.GA8918@opensource.wolfsonmicro.com>
References: <20100923124445.a2b5de42.sfr@canb.auug.org.au>
 <s5haan9ngg2.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5haan9ngg2.wl%tiwai@suse.de>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 08:04:45AM +0200, Takashi Iwai wrote:

> Ah, this was a quick fix for 2.6.36, but it needs to be reverted again
> for 2.6.37.  for-next branch contains 2.6.37 patches, thus it got
> broken.  I fixed now.  Mark, could you pull topic/asoc branch on my tree?

Will do, thanks.
