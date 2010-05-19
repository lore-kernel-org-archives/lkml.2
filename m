Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab0ESPAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:00:17 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42858 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab0ESPAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:00:15 -0400
Date: Wed, 19 May 2010 10:45:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 10/17] wireless: update gfp/slab.h includes
Message-ID: <20100519144505.GD2412@tuxdriver.com>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
 <1269885165-18617-11-git-send-email-tj@kernel.org>
 <20100519190230.52385a65.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519190230.52385a65.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 07:02:30PM +1000, Stephen Rothwell wrote:
> Hi John,
> 
> On Tue, 30 Mar 2010 02:52:38 +0900 Tejun Heo <tj@kernel.org> wrote:
> >
> > Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> > gfp.h or slab.h is included as necessary.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Cc: John W. Linville <linville@tuxdriver.com>

> I think that this patch is still needed in the wireless tree and I notice
> that Dave has asked Linus to pull the net tree (containing the wireless
> tree).  I have been carrying this in linux-next.

Looks like this was part of a series...who merged the rest of it?
I guess I presumed they would take care of the series.

Tejun, I wouldn't mind a repost, preferrably Cc:
linux-wireless@vger.kernel.org...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
