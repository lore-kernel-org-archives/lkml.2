Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568Ab2ERAEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:04:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:17171 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932585Ab2ERAEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:04:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101419389"
Date: Thu, 17 May 2012 17:04:04 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
cc: "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, Dean Nelson <dnelson@redhat.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] e1000: Reset rx ring index on receive overrun
In-Reply-To: <20120517233124.GK683@type.famille.thibault.fr>
Message-ID: <alpine.WNT.2.00.1205171702590.7900@jbrandeb-mobl2.amr.corp.intel.com>
References: <20120517230140.GZ683@type.famille.thibault.fr> <061C8A8601E8EE4CA8D8FD6990CEA891188439E0@ORSMSX102.amr.corp.intel.com> <20120517232821.GJ683@type.famille.thibault.fr> <20120517233124.GK683@type.famille.thibault.fr>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: amrjbrandeb@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="98638-26239-1337299446=:7900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--98638-26239-1337299446=:7900
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT



On Thu, 17 May 2012, Samuel Thibault wrote:

> Samuel Thibault, le Fri 18 May 2012 01:28:21 +0200, a écrit :
> > Dave, Tushar N, le Thu 17 May 2012 23:22:31 +0000, a écrit :
> > > I am interested in to see if you have actual test case and more 
> > > importantly test data that shows that kernel and device indexes are 
> > > not synchronized any more.
> > 
> > Well, it's not with an actual physical device, but with the kvm
> > emulation.
> 
> BTW, it also happens easily when request_irq takes some time to
> complete: since we enable E1000_TCTL_EN before that, the card can have
> time to fill the ring before irqs are processed.

I think there may well be a bug in the implementation in kvm.  The 
hardware doesn't have this bug.
--98638-26239-1337299446=:7900--
