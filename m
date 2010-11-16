Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607Ab0KPLhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:37:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58696 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933106Ab0KPLhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:37:12 -0500
Date: Tue, 16 Nov 2010 11:37:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Vladimir Barinov <vbarinov@embeddedalley.com>,
        Richard Purdie <richard@openedhand.com>
Subject: Re: [PATCH 0/5] ASoC: Fix incorrect kfree in error path
Message-ID: <20101116113709.GN12986@rakim.wolfsonmicro.main>
References: <1289894800.19543.2.camel@mola>
 <1289901165.3338.12.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289901165.3338.12.camel@odin>
X-Cookie: I like your SNOOPY POSTER!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 09:52:45AM +0000, Liam Girdwood wrote:
> On Tue, 2010-11-16 at 16:06 +0800, Axel Lin wrote:
> > This serial of patches fixes incorrect kfree in error path.

> All 

Applied, thanks.
