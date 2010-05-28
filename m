Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab0E1MQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 08:16:21 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:53269 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756805Ab0E1MQT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 08:16:19 -0400
X-AuditID: 12074422-b7c13ae000003829-33-4bffb412b456
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
Date: Fri, 28 May 2010 08:16:08 -0400
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <06439EEF-9404-45DC-AB37-5CC0486CCF6C@mit.edu>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk> <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org> <20100527230806.4deb6de3@lxorguk.ukuu.org.uk> <20100527220949.GB10602@srcf.ucam.org> <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk> <20100527223605.GB11364@srcf.ucam.org> <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk> <20100528043114.GC26177@thunk.org> <20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1078)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 28, 2010, at 5:37 AM, Alan Cox wrote:

>> Keep in mind, though, that a solution which is acceptable for Android
>> has to include making sure that crappy applications don't cause the
> 
> Ted if you are speaking for Android do you think you should post from a
> google address or with a google .sig ?

We're all engineers here.   Nobody speaks for the company as a whole without the permission of corporate PR, and that's true for Intel, IBM, and all other companies.

>> battery to get drained.  There seem to be some people who seem
>> adamently against this requirement.  From the Android folks'
>> perspective, this is part of what is required to have an open app
>> store, as opposed to one where each application has to be carefully
>> screened and approved ala the Apple iPhone App Store.
> 
> The other vendors appear to be managing nicely without magic blockers. I
> conjecture therefore there are other solutions.

I've seen very hard to debug situations  with Maemo where users are essentially asked to uninstall all their applications, and then install them back one at a time, waiting several hours between each install for a charge/discharge cycle, to figure out which application was waking up the system so !@#@! much while the screen was turned off.   And, when the periodic wakeups are faster than the refresh time of powertop, no, powertop won't help you find the crapplication.   If you think that's acceptable, fine --- we'll see who wins in the marketplace, and who gets blamed for producing a crappy platform --- the incompetent application programmer, or the platform supplier.

> If we don't have a solution it means that between us we couldn't find a
> viable solution. Maybe there isn't one, maybe we missed it. It's as much
> 'google rejects kernel approach' as 'kernel rejects google approach' and
> more importantly its actually 'we (cumulative) were not smart enough
> between us to figure it out'

Maybe.  And perhaps the right solution in that case is to merge both, as opposed to "consign one to the outer darkness".   And I think that's a decision Linus should make.

I do hope we can come up with a better solution, eventually.  But I do want to point out as a process point of view, we do have other alternates other than "spinning endlessly".

-- Ted

