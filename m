Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2JUQNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 12:13:06 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50097 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2JUQNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 12:13:04 -0400
Date: Sun, 21 Oct 2012 18:12:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] oprofile fixes
Message-ID: <20121021161258.GA27429@gmail.com>
References: <20121010071835.GA26201@elgon.mountain>
 <20121015143912.GP8285@erda.amd.com>
 <20121015144708.GQ8285@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015144708.GQ8285@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> On 15.10.12 16:39:12, Robert Richter wrote:
> > On 10.10.12 10:18:35, Dan Carpenter wrote:
> > > The "event" variable is a u16 so the shift will always wrap to zero
> > > making the line a no-op.
> > > 
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > Patch applied. Thanks for reporting and fixing.
> 
> please pull this fix for tip:perf/urgent from
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Pulled, thanks guys!

	Ingo
