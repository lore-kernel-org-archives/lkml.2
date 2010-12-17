Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0LQQV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 11:21:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab0LQQVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:21:55 -0500
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc6 for 2.6.37-rc6
From: James Bottomley <James.Bottomley@suse.de>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>,
        Joe Eykholt <jeykholt@cisco.com>, "J.H." <warthog9@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4D0B8975.1040206@vlnb.net>
References: <1292557664.31461.68.camel@haakon2.linux-iscsi.org>
	 <1292599364.2820.21.camel@mulgrave.site>  <4D0B8975.1040206@vlnb.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 11:21:48 -0500
Message-ID: <1292602908.2820.41.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 19:01 +0300, Vladislav Bolkhovitin wrote:
> James Bottomley, on 12/17/2010 06:22 PM wrote:
> > OK, I think this has reached the stage where it's been polished enough
> > outside mainline to the point where we can complete any remaining todo
> > items in-tree.
> > 
> > So lets begin merging with the minimal target core and the TCM_Loop as
> > two separate commits. I think the target core may just fit under the
> > reflector mail length limits, but if not, you can send it as multiple
> > patches and I'll recombine them.
> 
> Well, could somebody eventually explain what are advantages of LIO over
> SCST so you are choosing it?
> 
> LIO is obviously worse all technically (see
> http://scst.sourceforge.net/comparison.html) as well as in the number of
> users and size of the community. Current in-rush attempts to make LIO
> _look_ not worse than SCST changed nothing in this area.

To be honest, I don't really give a toss about niche feature
comparisons: both products have niche features the other doesn't.  The
basic requirements in both products are solid.  If the niche feature has
customer value, my estimation is that it can easily be added (to either
product).

> In the resent threads how many people voted for LIO? Nobody. How many
> for SCST? Many. Moreover, has any real user of LIO participated in those
> threads? None?

This isn't a democracy ... it's about choosing the most community
oriented code base so that it's easily maintainable and easy to add
feature requests and improvements as and when they come along.  In the
past six months, LIO has made genuine efforts to clean up its act,
streamline its code and support the other community projects that would
need to go above and around it.  You seem to have spent a lot of the
intervening time arguing with the sysfs maintainer about why you're
right and he's wrong.

James

> Doesn't that matter for you? Which code is the best doesn't matter for
> Linux anymore?
> 
> Undercover games are going on?
> 
> Vlad


