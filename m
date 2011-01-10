Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1AJSb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:31:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab1AJSbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:31:55 -0500
Date: Mon, 10 Jan 2011 10:23:17 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Oleg Nesterov <oleg@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG stable, 2.6.32.27] sched: delayed cleanup of user_struct
Message-ID: <20110110182317.GA16694@suse.de>
References: <4D2AB8F7.7030506@profihost.ag>
 <20110110114913.GA22298@redhat.com>
 <20110110123630.GA27057@redhat.com>
 <4D2AFFB5.5000807@profihost.ag>
 <20110110133545.GA30163@redhat.com>
 <4D2B113A.2060303@profihost.ag>
 <20110110140817.GA31708@redhat.com>
 <4D2B1658.20201@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2B1658.20201@profihost.ag>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 03:23:20PM +0100, Stefan Priebe - Profihost AG wrote:
> >>You can find the logs here:
> >>http://pastebin.com/hNd15E8K
> >
> >Good. Sadly, I didn't see this trace before...
> >
> >	kernel BUG at kernel/workqueue.c:287!
> >
> >this matches "INIT_DELAYED_WORK() can corrupt the pending work" I
> >mentioned.
> Sorry to ask this but this could also be "workarounded" by disabled
> GROUP_SCHED? Or is this another thing?
> 
> >>>Or. You can revert
> >>>	b00bc0b237055b4c45816325ee14f0bd83e6f590
> >>>	uids: Prevent tear down race
> >>>
> >>>	3959214f971417f4162926ac52ad4cd042958caa
> >>>	sched: delayed cleanup of user_struct
> >>Not sure if it is a good idea to introduce another race again.
> >
> >Which race? b00bc0b237055b4c45816325ee14f0bd83e6f590 fixes the race, yes.
> >But this race was introduced by 3959214f971417f4162926ac52ad4cd042958caa.
> >And afaics the latter commit is optimization...
> >
> >Anyway, this is up to you, of course.
> ah OK sorry didn't get this. Will wait if greg or anybody else can
> tell us something about it.

Tell us about what?  I'm totally confused here, what is the problem?

thanks,

greg k-h
