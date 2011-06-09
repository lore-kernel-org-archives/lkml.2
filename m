Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1FIKw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 06:52:28 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56725
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754720Ab1FIKw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 06:52:26 -0400
Date: Thu, 9 Jun 2011 06:52:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Cc: Mike Snitzer <snitzer@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
Message-ID: <20110609105220.GA3300@infradead.org>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 09:26:11PM +0300, Amir G. wrote:
> In my old next3.sf.net wiki, which I do update from time to time,
> I listed 4 advantages of Ext4 (then next3) snapshots over LVM:
> * Performance: only small overhead to write performance with snapshots
> * Scalability: no extra overhead per snapshot
> * Maintenance: no need to pre-allocate disk space for snapshots
> * Persistence: snapshots don't vanish when disk is full
> 
> As far as I know, the only thing that has changed from dm-snap
> to dm-multisnap is the Scalability.

I don't think you have looked at dm-multisnap at all, have you?  It
addresses all your points and many more.  Take a look at the code which
is in the multisnap branch of https://github.com/jthornber/linux-2.6/,
there's also some slides on it from Linuxtag at:

https://github.com/jthornber/storage-papers/blob/master/thinp-snapshots-2011/thinp-and-multisnap.otp?raw=true

