Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab0EMSx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:53:59 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:51591 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756474Ab0EMSx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:53:58 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 May 2010 14:53:57 EDT
From: Matt Fleming <matt@console-pimps.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-omap@vger.kernel.org, Madhusudhan Chikkature <madhu.cr@ti.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] MMC: OMAP HS-MMC: convert to dev_pm_ops
In-Reply-To: <1273615036-4516-1-git-send-email-khilman@deeprootsystems.com>
References: <1273615036-4516-1-git-send-email-khilman@deeprootsystems.com>
User-Agent: Notmuch/0.3.1-17-g59b1b66 (http://notmuchmail.org) Emacs/23.1.90.2 (x86_64-unknown-linux-gnu)
Date: Thu, 13 May 2010 19:48:14 +0100
Message-ID: <87k4r74p01.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 14:57:16 -0700, Kevin Hilman <khilman@deeprootsystems.com> wrote:
> 
> Note that dev_pm_ops version of the suspend hook no longer takes a
> 'state' argument.  However, the MMC core function mmc_suspend_host()
> still takes a 'state' argument, but it is unused, so a dummy
> state variable was created to pass to the MMC core.

Hmm.. instead of passing this dummy state argument why don't we just
remove the argument from mmc_suspend_host()? Like you said, it's unused,
so I don't see a reason to keep it around?
