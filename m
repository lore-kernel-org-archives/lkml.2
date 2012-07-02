Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab2GBJjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:39:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718Ab2GBJjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:39:31 -0400
Date: Mon, 2 Jul 2012 11:39:14 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlegacy: print how long queue was actually stuck
Message-ID: <20120702093913.GA9045@redhat.com>
References: <1340786187.1911.24.camel@x61.thuisdomein>
 <1341062406.1911.76.camel@x61.thuisdomein>
 <20120702090602.GA8286@redhat.com>
 <1341221563.1911.141.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341221563.1911.141.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 11:32:43AM +0200, Paul Bolle wrote:
> On Mon, 2012-07-02 at 11:06 +0200, Stanislaw Gruszka wrote:
> > On Sat, Jun 30, 2012 at 03:20:06PM +0200, Paul Bolle wrote:
> > For some reason we are not able to authenticate, what itself is a
> > problem. Maybe this is wrong key offset problem and that will
> > be fixed by Emmanuel patch.
> 
> Which I can only try if we fix the small problem you mentioned in your
> comment on Emmanuel's patch (reference
> <20120702082653.GA2479@redhat.com>, not yet archived on lkml.org), can't
> I?
Oh, you were not CCed, and lkml too, v2 patch is here:
http://marc.info/?l=linux-wireless&m=134121823510017&w=2

> > Regarding "Queue 2 stuck", there is another fix in iwlwifi that
> > did not make to iwlegacy, which perhaps could help. If not here
> > then maybe on suspend.  
> > 
> > commit 342bbf3fee2fa9a18147e74b2e3c4229a4564912
> > Author: Johannes Berg <johannes.berg@intel.com>
> > Date:   Sun Mar 4 08:50:46 2012 -0800
> > 
> >     iwlwifi: always monitor for stuck queues
> > 
> > I'm attaching iwlegacy version of it.
> 
> Thanks, I'll try it. The explanation of the iwlwifi commit makes a lot
> of sense: it seems to match the events found in the logs of this laptop.
> That's encouraging. Should I report whether the iwlegacy version works
> or not?
Actually I'll post it anyway. But if this patch and Emmanuel's will not 
fix the problem you should report it. 
   
> > > 2) It's always "Queue 2" that's stuck. What does that queue do?
> > 
> > It's TX queue, probably one used for default traffic i.e. for Best
> > Effort category (others are Video, Voice and Background).
> 
> I see.
> 
> Any thoughts on my patch (ie, the patch that is actually the subject of
> this thread?
It was applied to wireless-testing.

Stanislaw
