Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1LVGSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 01:18:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1LVGSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 01:18:02 -0500
Date: Wed, 21 Dec 2011 22:09:17 -0800
From: Greg KH <gregkh@suse.de>
To: Brian Swetland <swetland@google.com>
Cc: david@lang.hm, NeilBrown <neilb@suse.de>, Tim Bird <tim.bird@am.sony.com>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
Message-ID: <20111222060917.GA16302@suse.de>
References: <4EF264C3.6000104@am.sony.com>
 <20111221231956.GB23859@suse.de>
 <4EF27B85.9080801@am.sony.com>
 <20111222122026.3a0fae36@notabene.brown>
 <alpine.DEB.2.02.1112212050060.28597@asgard.lang.hm>
 <CANqkERBPayBWjFp2nCDZA2CByJQwHMoeXe62ZutZr8QkWtcTLg@mail.gmail.com>
 <alpine.DEB.2.02.1112212107550.28597@asgard.lang.hm>
 <CANqkERCH15aGi5TJwUk6Yg3fnrPA0aiTJa=Nz9sUeZLbWs20HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqkERCH15aGi5TJwUk6Yg3fnrPA0aiTJa=Nz9sUeZLbWs20HA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 09:25:52PM -0800, Brian Swetland wrote:
> Long term things could certainly move around, but *right now* we
> really don't see the value in gutting what we've got in favor of
> writing a new userspace daemon, which is going to require somebody to
> do that work, maintain it, chase down any behavioural quirks
> introduced by the changes, etc.  Or to throw it out in favor of trying
> to bolt our logging infrastructure on top of existing syslogds, etc.
> 
> We're happy to maintain the logger driver out of tree as we have for
> the past four years.

This all came about because Tim asked to merge this to the main tree
as-is, and so, people rightfully pointed out different options that
might be considered if it were to be merged that way.

I have no problem leaving the logger driver in staging, but it seems
that Tim is taking on the task to do the harder thing here, which
probably would entail work on both sides, which as a openhandset
alliance company member, he might have a change that someone like me
might not :)

Tim, it's now in your court it seems, have a great holiday,

greg k-h
