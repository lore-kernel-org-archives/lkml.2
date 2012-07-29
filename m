Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2G2NBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 09:01:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:8695 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab2G2NBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 09:01:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="189395478"
Date: Sun, 29 Jul 2012 21:01:42 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        "kernel-janitors@vger.kernel..." <kernel-janitors@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: appletalk/cops_probe BUG: soft lockup - CPU#1 stuck for 23s!
Message-ID: <20120729130142.GA17155@localhost>
References: <20120729124022.GA16748@localhost>
 <20120729140003.6fa483d2@ultron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120729140003.6fa483d2@ultron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 02:00:03PM +0100, Alan Cox wrote:
> On Sun, 29 Jul 2012 20:40:22 +0800
> Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > Hi,
> > 
> > This is probably a rather old bug, triggered while doing randconfig
> > boot tests in kvm:
> 
> I'm not sure testing old devices with no safe probe method is useful in
> this context ?

Yeah. I'll just blacklist this driver in my builds.

Thanks,
Fengguang
