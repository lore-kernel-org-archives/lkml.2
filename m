Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab0E1MdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 08:33:18 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:58318 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973Ab0E1MdQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 08:33:16 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2010 08:33:16 EDT
X-AuditID: 12074423-b7c0bae0000030f0-10-4bffb6de6807
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <06439EEF-9404-45DC-AB37-5CC0486CCF6C@mit.edu>
Date: Fri, 28 May 2010 08:28:06 -0400
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <CC8B666C-545E-455A-BC03-FCCF20F936C8@mit.edu>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk> <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org> <20100527230806.4deb6de3@lxorguk.ukuu.org.uk> <20100527220949.GB10602@srcf.ucam.org> <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk> <20100527223605.GB11364@srcf.ucam.org> <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk> <20100528043114.GC26177@thunk.org> <20100528103713.0a7952d9@lxorguk.ukuu.org.uk> <06439EEF-9404-45DC-AB37-5CC0486CCF6C@mit.edu>
To: Theodore Tso <tytso@MIT.EDU>
X-Mailer: Apple Mail (2.1078)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 28, 2010, at 8:16 AM, Theodore Tso wrote:
> 
> I've seen very hard to debug situations  with Maemo where users are essentially asked to uninstall all their applications, and then install them back one at a time, waiting several hours between each install for a charge/discharge cycle, to figure out which application was waking up the system so !@#@! much while the screen was turned off.   And, when the periodic wakeups are faster than the refresh time of powertop, no, powertop won't help you find the crapplication.   

Sorry, miswording:   s/faster/less frequent/

I'm not convinced CPU activity LEDs help either, BTW.    It only takes the CPU getting crowbarred out of idle for a tiny amount of time before you start impacting battery life, and if the crapplication is only doing it every 30-60 seconds or so, I doubt you'd see it on the LED's....  that sort of thing might be acceptable if you have a 1-3 pound battery, but maybe much less so if you have a bettery which is cell-phoned sized.

-- Ted


