Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab2I2JBZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 05:01:25 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:59612 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab2I2JBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 05:01:22 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApdbAD24ZlBV5h1yPGdsb2JhbABFhUWFALNrGQEBAQEfGQ0ngiABAQQBOhwjEAgDDjgUJQoaiBIKuUMUkHZgA5VohXKNIw
X-IronPort-AV: E=Sophos;i="4.80,508,1344204000"; 
   d="scan'208";a="201735226"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 29 Sep 2012 11:02:17 +0200
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Input and HID updates for 3.7
Message-ID: <20120929090217.GA1290@polaris.bitmath.org>
References: <20120919185605.GA778@polaris.bitmath.org>
 <alpine.LNX.2.00.1209192351120.22959@pobox.suse.cz>
 <20120928173539.GB6356@core.coreip.homeip.net>
 <alpine.LNX.2.00.1209282218350.17437@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1209282218350.17437@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hmm, it looks like the work on making evdev using dynamic device numbers
> > will clash with Henrik's changes. I think I will also pull this into my
> > tree and then git should be able to resolve it all properly in -next.
> 
> That should work. Alternatively you can pull 'from-henrik' branch from my 
> tree in case Henrik has already ditched/rebased his tree.

The tree will remain the same until after 3.7-rc1 is out, so pulling
should be fine.

Thanks,
Henrik
