Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0EGOUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:20:33 -0400
Received: from poutre.nerim.net ([62.4.16.124]:55844 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab0EGOUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:20:32 -0400
Date: Fri, 7 May 2010 16:20:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: platform_bus: Allow runtime PM by default
Message-ID: <20100507162028.022a737c@hyperion.delvare>
In-Reply-To: <20100507132746.GA3425@sirena.org.uk>
References: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<201004231840.20041.rjw@sisk.pl>
	<201004232026.37114.rjw@sisk.pl>
	<201004232041.42064.rjw@sisk.pl>
	<20100507132746.GA3425@sirena.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, 7 May 2010 14:27:46 +0100, Mark Brown wrote:
> On Fri, Apr 23, 2010 at 08:41:41PM +0200, Rafael J. Wysocki wrote:
> 
> > Jean, the patch we're discussing depends on the
> > "i2c: Fix bus-level power management callbacks" patch that's in your tree right
> > now.  Would it be possible to move the i2c patch to my tree, or alternatively
> > would it be acceptable for you to merge a core PM patch through your tree?
> 
> Jean, any updates on this?

I'm sorry, I never received Rafael's initial message. I just checked
through my mailbox and it isn't there.

The current status is that patch "i2c: Fix bus-level power management
callbacks" is currently queued in my i2c tree at:
ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/i2c-fix-bus-level-power-management-callbacks.patch
and is scheduled to be merged in 2.6.35-rc1. If this isn't OK, we can
change the plan.

Merging a core PM patch through the i2c tree would be quite confusing,
I think, and might draw even more odd dependencies. So I'd rather have
the i2c patch moved to the PM staging tree (or whatever tree the
dependent patch lives in.) Just let me know and I'll drop my copy.

-- 
Jean Delvare
