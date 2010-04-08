Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab0DHTrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:47:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:36475 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933243Ab0DHTrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:47:16 -0400
Subject: Re: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6.
 v2.6.34-rc3-406 oops with 4965AGN wireless
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Shanyu Zhao <shanyu.zhao@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, johannes@sipsolutions.net
In-Reply-To: <alpine.LFD.2.00.1004081017360.3558@i5.linux-foundation.org>
References: <Pine.LNX.4.64.1004090104570.7829@boston.corp.fedex.com>
	 <alpine.LFD.2.00.1004081017360.3558@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 21:47:13 +0200
Message-ID: <1270756033.20295.2982.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 10:19 -0700, Linus Torvalds wrote:
> 
> On Fri, 9 Apr 2010, Jeff Chua wrote:
> > 
> > I'm having problem with the latest git pull 2 days ago with the 4965AGN
> > wireless.
> > 
> > Starting the wireless with WPA2 resulted in system hard freeze. Reverting the
> > commit below solves the problem.
> 
> I don't mind reverting patches, but I hate doing it blind and without 
> _any_ chance for the guilty party to try to fix it first.
> 
> Can you post the oops that your subject implies happened? Maybe the driver 
> authors can find the proper fix without a revert?
> 
> I'll revert if if I hear no updates in a couple of days - please remind 
> me.

Does remind me of the iwlagn trouble I had, see
https://bugzilla.kernel.org/show_bug.cgi?id=15667 and
https://bugzilla.kernel.org/attachment.cgi?id=25881 for a patch that
seems to have cured my laptop.

