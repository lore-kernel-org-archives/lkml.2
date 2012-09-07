Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417Ab2IGD0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:26:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:57527 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab2IGD0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:26:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="219157966"
Date: Fri, 7 Sep 2012 11:26:28 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tomas Hlavacek <tmshlvck@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty: WARNING at drivers/base/core.c:196 device_release()
Message-ID: <20120907032628.GA15378@localhost>
References: <20120907022928.GA14646@localhost>
 <20120907024613.GA28505@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907024613.GA28505@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 07:46:13PM -0700, Greg KH wrote:
> On Fri, Sep 07, 2012 at 10:29:28AM +0800, Fengguang Wu wrote:
> > Hi Tomas,
> > 
> > FYI, this commit triggers a boot time warning.
> > 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git tty-next
> > head:   6915c0e487c822e2436683e14302c0b8a6155cc7
> > commit: 6915c0e487c822e2436683e14302c0b8a6155cc7 [1/1] tty: uartclk value from serial_core exposed to sysfs
> 
> Should now be fixed in my tree with a later patch, from Tomas, right?

Yes! The new head b1b7991 is fine.

Thanks,
Fengguang
