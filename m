Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab0EKGTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:19:09 -0400
Received: from poutre.nerim.net ([62.4.16.124]:54694 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab0EKGTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:19:04 -0400
Date: Tue, 11 May 2010 08:19:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, Greg KH <gregkh@suse.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: platform_bus: Allow runtime PM by default
Message-ID: <20100511081900.0e7a1956@hyperion.delvare>
In-Reply-To: <201005102310.55838.rjw@sisk.pl>
References: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20100507132746.GA3425@sirena.org.uk>
	<20100507162028.022a737c@hyperion.delvare>
	<201005102310.55838.rjw@sisk.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 23:10:55 +0200, Rafael J. Wysocki wrote:
> On Friday 07 May 2010, Jean Delvare wrote:
> > I'm sorry, I never received Rafael's initial message. I just checked
> > through my mailbox and it isn't there.
> > 
> > The current status is that patch "i2c: Fix bus-level power management
> > callbacks" is currently queued in my i2c tree at:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/i2c-fix-bus-level-power-management-callbacks.patch
> > and is scheduled to be merged in 2.6.35-rc1. If this isn't OK, we can
> > change the plan.
> > 
> > Merging a core PM patch through the i2c tree would be quite confusing,
> > I think, and might draw even more odd dependencies. So I'd rather have
> > the i2c patch moved to the PM staging tree (or whatever tree the
> > dependent patch lives in.) Just let me know and I'll drop my copy.
> 
> The patch above has been applied to suspend-2.6/linux-next along with the
> Mark's $subject patch.

OK, I've dropped it from my i2c tree.

> I have converted your sign-off into an ack, hope that's fine.

Perfectly fine, yes, thanks.

-- 
Jean Delvare
