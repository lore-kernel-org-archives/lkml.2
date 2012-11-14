Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab2KNSF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:05:59 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56815 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab2KNSF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:05:57 -0500
Date: Wed, 14 Nov 2012 10:05:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] input: fix input-mt kernel-doc warning
Message-ID: <20121114180552.GD29131@core.coreip.homeip.net>
References: <5099B45E.8080105@infradead.org>
 <20121107194617.GA3738@polaris.bitmath.org>
 <20121108170431.GD8877@core.coreip.homeip.net>
 <20121108175609.GA11114@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121108175609.GA11114@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 06:56:09PM +0100, Henrik Rydberg wrote:
> Hi Dmitry,
> 
> > > > From: Randy Dunlap <rdunlap@infradead.org>
> > > > 
> > > > Fix new kernel-doc warning in input-mt.c:
> > > > 
> > > > Warning(drivers/input/input-mt.c:38): No description found for parameter 'flags'
> > > 
> > > Thanks for the patch. It seemed reasonable to expand the function
> > > documentation a bit as well, hope you are alright with the patch
> > > below, Dmitry, care to pick this up for 3.7? Otherwise I can carry it
> > > for 3.8.
> > 
> > Randy, Henrik,
> > 
> > I'll try getting it in 3.7.
> 
> Seems there were more warnings introduced in 3.7-rc1... adding the
> patch below seems to fix all of them. I guess you want to merge the
> former patch into this one.

Ended up on putting all in 3.8 queue as it clashed with some other data
members I added to struct inptu_dev.

Thanks.

-- 
Dmitry
