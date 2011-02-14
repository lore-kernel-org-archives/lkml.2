Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1BNO35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:29:57 -0500
Received: from fieldses.org ([174.143.236.118]:34346 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab1BNO3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:29:54 -0500
Date: Mon, 14 Feb 2011 09:29:49 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Tino Keitel <tino.keitel@tikei.de>, Neil Brown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc3: kernel BUG at fs/nfsd/nfs4state.c:3132!
Message-ID: <20110214142949.GA19748@fieldses.org>
References: <20110211153702.GC3005@fieldses.org>
 <s5hwrl6a7ch.wl%tiwai@suse.de>
 <20110211160532.GD3005@fieldses.org>
 <s5hsjvua6tq.wl%tiwai@suse.de>
 <s5hhbcamrv2.wl%tiwai@suse.de>
 <s5hd3mymrr3.wl%tiwai@suse.de>
 <20110211170036.GF3005@fieldses.org>
 <20110211174312.GH3005@fieldses.org>
 <s5hvd0q4eue.wl%tiwai@suse.de>
 <s5hhbc6n914.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhbc6n914.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 12:35:35PM +0100, Takashi Iwai wrote:
> At Fri, 11 Feb 2011 19:15:53 +0100,
> Takashi Iwai wrote:
> > 
> > At Fri, 11 Feb 2011 12:43:12 -0500,
> > J. Bruce Fields wrote:
> > > 
> > > On Fri, Feb 11, 2011 at 12:00:36PM -0500, J. Bruce Fields wrote:
> > > > On Fri, Feb 11, 2011 at 05:59:44PM +0100, Takashi Iwai wrote:
> > > > > Argh, too early to say.  Now I got the same one.
> > > > > 
> > > > > It seems that it's triggered when I start Firefox on NFS client
> > > > > machine.
> > > > 
> > > > OK, thanks, I'll take a look.
> > > 
> > > I think I see the problem....  Could you try fetching that branch again?
> > > 
> > > 	git://linux-nfs.org/~bfields/linux-topics.git for-2.6.38-incoming
> > > 
> > > (But I've only tested that it compiles so far.)
> > 
> > Sorry, I already left my office and have no access to the machine.
> > I'll test it on Monday if Tino can't test it beforehand.
> 
> I've been testing it for hours, and so far this looks good.
> FireFox starts and doesn't trigger BUG().

Good, thanks for the testing.

--b.
