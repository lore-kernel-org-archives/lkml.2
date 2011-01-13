Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab1AMU3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:29:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60559 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab1AMU3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:29:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] i2c: Factor out runtime suspend checks from PM operations
Date: Thu, 13 Jan 2011 21:28:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-i2c@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Ben Dooks <ben-linux@fluff.org>
References: <1293712813-4090-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201101050928.53979.rjw@sisk.pl> <20110113211751.62e878d8@endymion.delvare>
In-Reply-To: <20110113211751.62e878d8@endymion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101132128.57839.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 13, 2011, Jean Delvare wrote:
> Hi Rafael,
> 
> On Wed, 5 Jan 2011 09:28:53 +0100, Rafael J. Wysocki wrote:
> > On Wednesday, January 05, 2011, Mark Brown wrote:
> > > On Tue, Jan 04, 2011 at 03:07:37PM -0800, Abhijeet Dharmapurikar wrote:
> > > > Mark Brown wrote:
> > > 
> > > >> device op. The PM core provides pm_generic_ functions implementing this
> > > >> behaviour - use them to reduce coupling with future PM updates.
> > > 
> > > > pm_generic_suspend() and others needs to be externed in linux/pm_runtime.h?
> > > 
> > > Yes, there's a patch in -next for this already so this patch would need
> > > to either wait for later in the merge window or go in via the PM tree
> > > with the preceeding one (the original version of this patch was posted
> > > as part of a series with the export patch).
> > 
> > I would take it, but I'm still waiting for a word from Jean.
> 
> Sorry for the long silence, I was on vacation. I've just applied this
> patch, and I will send it to Linus tomorrow.

Great, thanks!

Rafael
