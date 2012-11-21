Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab2KUSls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:41:48 -0500
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:46251 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab2KUSlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:41:47 -0500
Subject: Re: [PATCH 000/493] remove CONFIG_HOTPLUG as an option
To: akpm@linux-foundation.org (Andrew Morton)
Date: Wed, 21 Nov 2012 13:41:46 -0500
Cc: grant.likely@secretlab.ca (Grant Likely), gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20121120235659.95001487.akpm@linux-foundation.org>
X-Mailer: ELM [version 2.5.8.59.gd925]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121121184146.A9BCB8013C@viridian.itc.virginia.edu>
From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:
> 
> On Tue, 20 Nov 2012 10:46:11 +0000 Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > On Sat, Nov 17, 2012 at 12:19 AM, Bill Pemberton <wfp5p@virginia.edu> wrote:
> > > CONFIG_HOTPLUG is no longer an optional setting.  In order to remove
> > > it as on option code paths that check CONFIG_HOTPLUG will removed
> > > along with the attributes __devexit_p, __devexit, __devinitconst, and
> > > __devinitdata.
> > >
> > > I'll save the list from the mailbomb of this huge patchset.  The
> > > patches themselves are going to Greg KH for the driver core tree.
> > >
> > >
> > > Bill Pemberton (493):
> > [...]
> > >  2942 files changed, 11645 insertions(+), 12116 deletions(-)
> > 
> > So, I've got no problem with the reason for the change and I don't
> > even think you need my ack for the bits that I maintain (though you
> > have it if you want it). However, this looks like it is going to be
> > /painful/. First of all it will touch a huge number of files in the
> > tree. Yes the change is trivial, but it will require manual fixups on
> > a lot of patches.
> 
> Yeah, this is dopey.  Send the script to Linus and ask him to run it
> seven seconds before he releases -rc1, when everyone's trees are
> empty(ish).  Or send him a single megapatch at that time.
> 

I like the script idea for removing all the __dev markings.  Creating
the patches in the first place was a game of whack-a-mole as various
trees changed.

-- 
Bill

