Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2HMVow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:44:52 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52535 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2HMVov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:44:51 -0400
Date: Mon, 13 Aug 2012 14:44:46 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Joseph Glanville <joseph.glanville@orionvm.com.au>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net,
        yehuda@hq.newdream.net, snitzer@redhat.com
Subject: Re: [PATCH v5 02/12] dm: Use bioset's front_pad for
 dm_rq_clone_bio_info
Message-ID: <20120813214446.GC9541@google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-3-git-send-email-koverstreet@google.com>
 <20120808220612.GA6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120808235731.GA7262@moria.home.lan>
 <CAOzFzEhPW5-edb6mnL2gNbb4956u2MbWqQovv01010PyBCbc+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOzFzEhPW5-edb6mnL2gNbb4956u2MbWqQovv01010PyBCbc+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 03:24:45PM +1000, Joseph Glanville wrote:
> Hi Kent, Tejun
> 
> On 9 August 2012 09:57, Kent Overstreet <koverstreet@google.com> wrote:
> >> Also, how was this tested?
> >
> > Well, AFAICT the only request based dm target is multipath, and from the
> > documentation I've seen it doesn't appear to work without multipath
> > hardware, or at least I haven't seen it documented how. So, unless
> > there's another user I missed it's not been tested.
> 
> Multipath can be tested quite easily with a loopback scsi target, you
> don't require specialized hardware.
> The easiest way to do this would probably be the built in LIO target +
> open_iscsi initiator.
> 
> I haven't attempted running this current version of the patch series
> but I haven't run into issues with bcache+multipath in the past.

Actually, I bet you have been running this code - do you think you could
check the git log for the version you're running? That'd be awesome if
you are.
