Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003Ab0DHUPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:15:30 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51479 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab0DHUP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:15:29 -0400
Date: Thu, 8 Apr 2010 16:02:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       "Zhao, Shanyu" <shanyu.zhao@intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "stable@kernel.org" <stable@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6.
	v2.6.34-rc3-406 oops with 4965AGN wireless
Message-ID: <20100408200218.GC2999@tuxdriver.com>
References: <Pine.LNX.4.64.1004090251210.11582@boston.corp.fedex.com> <Pine.LNX.4.64.1004090336410.22139@boston.corp.fedex.com> <1270759800.19330.19.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270759800.19330.19.camel@wwguy-ubuntu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 01:50:00PM -0700, Guy, Wey-Yi wrote:

> I attach here again in case you did not get it.
> 
> Thanks
> Wey
> 
> 

> From f3a5f691e32c0edfbc42a1e8687392dc3efe396e Mon Sep 17 00:00:00 2001
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date: Thu, 8 Apr 2010 13:17:37 -0700
> Subject: [PATCH 1/1] iwlwifi: need check for valid qos packet before free
> 
> For 4965, need to check it is valid qos frame before free, only valid
> QoS frame has the tid used to free the packets.
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

I would prefer to take this through the normal wireless-2.6 route if
you don't mind.  Are you satisifed with this version?

Thanks,

John

P.S.  In the future, I'm also quite open to revert requests as needed.
It makes my life easier for things (even reverts) under wireless to
come through my tree rather than trying to figure-out how something
happened later...
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
