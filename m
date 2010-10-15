Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab0JOTaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:30:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42806 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab0JOTaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:30:15 -0400
Date: Fri, 15 Oct 2010 15:26:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Berg <johannes@sipsolutions.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] mac80211: cancel restart_work explicitly
 instead of depending on flush_scheduled_work()
Message-ID: <20101015192645.GA2438@tuxdriver.com>
References: <4CB874C0.8090003@kernel.org>
 <1287159715.1870.11.camel@Nokia-N900-51-1>
 <4CB883C9.6050104@kernel.org>
 <201010151858.45000.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010151858.45000.chunkeey@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 06:58:44PM +0200, Christian Lamparter wrote:
> On Friday 15 October 2010 18:39:37 Tejun Heo wrote:
> > Hello,
> 
> > >> -    /*
> > >> -     * For key todo, it'll be empty by now but the work
> > >> -     * might still be scheduled.
> > >> -     */
> > >> -    flush_scheduled_work();
> > > 
> > > oops, todo work no longer exists...
> > > 
> > > Anyway, ACK.
> > 
> > Are you going to route this through wireless tree?  Shall I repost
> > with update patch description?
> 
> wireless-testing/wireless-next has already such a patch:
> "mac80211: cancel restart_work in ieee80211_unregister_hw" (2010-08-25)
> 
> <http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=258086a48b766d12a500f98834654ffa927ca475>
> 
> John, can you please push to 2.6.36-rc8?
> (I know, I am _late_, but I didn't know about any potential problem
> in the mainline?)

I don't see how either patch would merit inclusion in 2.6.36 at this point.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
