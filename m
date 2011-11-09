Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab1KITwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:52:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab1KITwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:52:16 -0500
Date: Wed, 9 Nov 2011 20:51:57 +0100
From: Karel Zak <kzak@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] block: Revert "[SCSI] genhd: add a new attribute
	"alias" in gendisk"
Message-ID: <20111109195157.GN16397@nb.net.home>
References: <20111109162512.GB1260@google.com> <1320859800.8294.27.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320859800.8294.27.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 11:30:00AM -0600, James Bottomley wrote:
> On Wed, 2011-11-09 at 08:25 -0800, Tejun Heo wrote:
> > This reverts commit a72c5e5eb738033938ab30d6a634b74d1d060f10.
[...]
> No, I can't agree with this ... if you propose a working alternative,
> I'm listening, but in the absence of one, I think the hack fills a gap

 "The hack fills a gap" -- the definitive guide to Operation System
 API designing by James Bottomley; ISBN-666-666.

 ;-)

 If you open this Pandora's box then one day end-users will ask for
 the feature in all userspace utils. It's not about printk() only,
 it's about aliases for block devices. It's pretty invasive from
 long-term point of view...

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
