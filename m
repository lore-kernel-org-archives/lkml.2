Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912Ab2FGROg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:14:36 -0400
Received: from relay1.sgi.com ([192.48.179.29]:36292 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab2FGROf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:14:35 -0400
Date: Thu, 7 Jun 2012 12:14:34 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] watchdog: reduce "NMI watchdog enabled, takes one
	hw-pmu counter." messages
Message-ID: <20120607171433.GA21139@gulag1.americas.sgi.com>
References: <20120606180946.GA16566@gulag1.americas.sgi.com> <20120606211523.GF32472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606211523.GF32472@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 05:15:23PM -0400, Don Zickus wrote:
> On Wed, Jun 06, 2012 at 01:09:46PM -0500, Nathan Zimmer wrote:
> >  watchdog: reduces some noise on a large system
> >  The printk buffer can be flooded with with redundant
> >  "NMI watchdog enabled, takes one hw-pmu counter." messages.
> >  It doesn't add any value beyond the first.
> > 
> >  Note the message needs logged a second time if the watchdog was disabled then
> >  reenabled.
> 
> Hi Nathan,
> 
> Thanks for the patch.  I added something similar to RHEL-6 a while ago
> that solved the same problem in a more robust way (I think).  IOW, I dealt
> with the watchdog failures too (for virt and bios issues).
> 
> It doesn't cover the nmi_disable case like your patch does, but is easy to
> add.
> 
> I attached it below.  Let me know if this meets your needs or not?
> 
> Cheers,
> Don

Yes it does seem to meet my needs quite well.

Thanks,
Nate 
