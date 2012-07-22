Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2GVQqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 12:46:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49911 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2GVQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 12:46:13 -0400
Date: Sun, 22 Jul 2012 09:46:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] kthread_worker: reorganize to prepare for
 flush_kthread_work() reimplementation
Message-ID: <20120722164607.GB5144@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120719211510.GA32763@google.com>
 <20120719211541.GB32763@google.com>
 <1342890808.2504.3.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342890808.2504.3.camel@palomino.walls.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jul 21, 2012 at 01:13:27PM -0400, Andy Walls wrote:
> > +/* insert @work before @pos in @worker */
> 
> Hi Tejun,
> 
> Would a comment that the caller should be holding worker->lock be useful
> here?  Anyway, comment or not:
> 
> Acked-by: Andy Walls <awall@md.metrocast.net>

Will add lockdep_assert_held().  Thanks!

-- 
tejun
