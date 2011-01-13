Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab1AMUSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:18:09 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:36570 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727Ab1AMUSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:18:01 -0500
Date: Thu, 13 Jan 2011 21:17:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-i2c@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] i2c: Factor out runtime suspend checks from PM
 operations
Message-ID: <20110113211751.62e878d8@endymion.delvare>
In-Reply-To: <201101050928.53979.rjw@sisk.pl>
References: <1293712813-4090-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<4D23A839.6030205@codeaurora.org>
	<20110104231021.GA18024@sirena.org.uk>
	<201101050928.53979.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Wed, 5 Jan 2011 09:28:53 +0100, Rafael J. Wysocki wrote:
> On Wednesday, January 05, 2011, Mark Brown wrote:
> > On Tue, Jan 04, 2011 at 03:07:37PM -0800, Abhijeet Dharmapurikar wrote:
> > > Mark Brown wrote:
> > 
> > >> device op. The PM core provides pm_generic_ functions implementing this
> > >> behaviour - use them to reduce coupling with future PM updates.
> > 
> > > pm_generic_suspend() and others needs to be externed in linux/pm_runtime.h?
> > 
> > Yes, there's a patch in -next for this already so this patch would need
> > to either wait for later in the merge window or go in via the PM tree
> > with the preceeding one (the original version of this patch was posted
> > as part of a series with the export patch).
> 
> I would take it, but I'm still waiting for a word from Jean.

Sorry for the long silence, I was on vacation. I've just applied this
patch, and I will send it to Linus tomorrow.

-- 
Jean Delvare
