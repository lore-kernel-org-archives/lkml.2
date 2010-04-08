Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab0DHUcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:32:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:51536 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933582Ab0DHUby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:31:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,172,1270450800"; 
   d="scan'208";a="787594250"
Subject: Re: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6.
 v2.6.34-rc3-406 oops with 4965AGN wireless
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       "Zhao, Shanyu" <shanyu.zhao@intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "stable@kernel.org" <stable@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20100408200218.GC2999@tuxdriver.com>
References: <Pine.LNX.4.64.1004090251210.11582@boston.corp.fedex.com>
	 <Pine.LNX.4.64.1004090336410.22139@boston.corp.fedex.com>
	 <1270759800.19330.19.camel@wwguy-ubuntu>
	 <20100408200218.GC2999@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 08 Apr 2010 14:28:27 -0700
Message-Id: <1270762107.20845.3.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Thu, 2010-04-08 at 13:02 -0700, John W. Linville wrote:
> On Thu, Apr 08, 2010 at 01:50:00PM -0700, Guy, Wey-Yi wrote:
> 
> > I attach here again in case you did not get it.
> > 
> > Thanks
> > Wey
> > 
> > 
> 
> > From f3a5f691e32c0edfbc42a1e8687392dc3efe396e Mon Sep 17 00:00:00 2001
> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > Date: Thu, 8 Apr 2010 13:17:37 -0700
> > Subject: [PATCH 1/1] iwlwifi: need check for valid qos packet before free
> > 
> > For 4965, need to check it is valid qos frame before free, only valid
> > QoS frame has the tid used to free the packets.
> > 
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> I would prefer to take this through the normal wireless-2.6 route if
> you don't mind.  Are you satisifed with this version?
> 

Thanks for the help, the finial version should take care of the problem
and ready for upstream .

Regards
Wey
> 
> P.S.  In the future, I'm also quite open to revert requests as needed.
> It makes my life easier for things (even reverts) under wireless to
> come through my tree rather than trying to figure-out how something
> happened later...

