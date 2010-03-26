Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab0CZBGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:06:37 -0400
Received: from mail.atheros.com ([12.36.123.2]:13883 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab0CZBGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:06:35 -0400
Date: Thu, 25 Mar 2010 18:06:34 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bruno Randolf <br1@einfach.org>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Derek Smithies <derek@indranet.co.nz>,
       "bob@bobcopeland.com" <bob@bobcopeland.com>,
       "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       <johannes@sipsolutions.net>, <linville@tuxdriver.com>,
       <nbd@openwrt.org>, <linux-kernel@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>, <greg@kroah.com>
Subject: Re: [ath5k-devel] [PATCH 00/10] ANI for ath5k
Message-ID: <20100326010634.GB2385@tux>
References: <20100325054603.10697.48915.stgit@tt-desk>
 <201003260927.57491.br1@einfach.org>
 <20100326004431.GA2385@tux>
 <201003260953.49021.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201003260953.49021.br1@einfach.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a few more people for wider review on this.

On Thu, Mar 25, 2010 at 05:53:48PM -0700, Bruno Randolf wrote:
> On Friday 26 March 2010 09:44:31 Luis R. Rodriguez wrote:
> > > as well, we all agree that there should be userland controls. the
> > > questions is just about the interface to use.
> > 
> > ANI is specific to Atheros cards so debugfs would do it. If we want to
> > have a more rigit API we could use a configfs entry for ath9k.
> 
> debugfs definetly is the wrong place! users might compile the module with 
> debugging disabled (for performance reasons, e.g.).
> 
> are you sure about configfs? as far as i read about it it's for the dynamic 
> creation of kernel objects, which is not what we are doing here. or did the 
> rules change in the mean time?

I intended on writing a file system API for 802.11 management a while
ago through configfs, the only reason why I put it aside is our focus
was to get a netlink based API done. I think its reasonable to use
it for configuration of specific devices parameters though given that
we don't have a private API through nl80211.

  Luis
