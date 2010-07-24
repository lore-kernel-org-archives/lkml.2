Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0GXPsq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 11:48:46 -0400
Received: from support.opsdc.com ([65.254.219.9]:59790 "EHLO support.opsdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab0GXPsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 11:48:45 -0400
X-Greylist: delayed 3273 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Jul 2010 11:48:45 EDT
Subject: Re: [BUG] dm9601 driver won't init device properly
From: Chris Fowler <cfowler@outpostsentinel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Bob Tracy <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org,
        linux-net@vger.kernel.org
In-Reply-To: <93420.1279982681@localhost>
References: <20100723195736.GA4321@gherkin.frus.com>
	 <93420.1279982681@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Jul 2010 10:54:02 -0400
Message-ID: <1279983242.11931.4.camel@cfowler-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-24 at 10:44 -0400, Valdis.Kletnieks@vt.edu wrote:
> Wow. An "ethernet" card that won't do an MTU of 1500 even under
> Windows.  May I
> add this to my gallery of examples I use when people say "no vendor
> could
> *possibly* ship hardware that fscked up"? :) 

A lot of these "cards" are not meant for you and I.  They are meant for
casual desktop users that would never put any amount of load on them.

About 6 years ago we needed some PCMCIA modem cards and bought 100 of
them from a vendor for $25/ea.  They started failing in the field.  When
calling they just could not sync up.  Only a reboot could fix the
problem.  What we learned was that a combination of heat and other
factors caused them to drift so much the timing was off.  We replaced
those in the field with Zoom 3075 at about $65/ea.  These modems were
not meant for our solution.  They were meant for casual laptop users
that needed to dial an ISP every so often.  I was expecting them to work
in a box that would stay up 24x7.  They couldn't handle it.  I wrote a
perl program that used a TLS-4 simulator and would dial the modem
constantly.  The failures were too much.  On the Zooms we would average
10 failures per 1000 calls.





