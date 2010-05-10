Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab0EJVJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:09:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38134 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757183Ab0EJVJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:09:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: platform_bus: Allow runtime PM by default
Date: Mon, 10 May 2010 23:10:55 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, Greg KH <gregkh@suse.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20100507132746.GA3425@sirena.org.uk> <20100507162028.022a737c@hyperion.delvare>
In-Reply-To: <20100507162028.022a737c@hyperion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005102310.55838.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 May 2010, Jean Delvare wrote:
> Hi Mark,
> 
> On Fri, 7 May 2010 14:27:46 +0100, Mark Brown wrote:
> > On Fri, Apr 23, 2010 at 08:41:41PM +0200, Rafael J. Wysocki wrote:
> > 
> > > Jean, the patch we're discussing depends on the
> > > "i2c: Fix bus-level power management callbacks" patch that's in your tree right
> > > now.  Would it be possible to move the i2c patch to my tree, or alternatively
> > > would it be acceptable for you to merge a core PM patch through your tree?
> > 
> > Jean, any updates on this?
> 
> I'm sorry, I never received Rafael's initial message. I just checked
> through my mailbox and it isn't there.
> 
> The current status is that patch "i2c: Fix bus-level power management
> callbacks" is currently queued in my i2c tree at:
> ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/i2c-fix-bus-level-power-management-callbacks.patch
> and is scheduled to be merged in 2.6.35-rc1. If this isn't OK, we can
> change the plan.
> 
> Merging a core PM patch through the i2c tree would be quite confusing,
> I think, and might draw even more odd dependencies. So I'd rather have
> the i2c patch moved to the PM staging tree (or whatever tree the
> dependent patch lives in.) Just let me know and I'll drop my copy.

The patch above has been applied to suspend-2.6/linux-next along with the
Mark's $subject patch.

I have converted your sign-off into an ack, hope that's fine.

Thanks,
Rafael
