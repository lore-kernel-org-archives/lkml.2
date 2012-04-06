Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2DFO7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 10:59:23 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39686
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754840Ab2DFO7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:59:21 -0400
Date: Fri, 6 Apr 2012 10:59:15 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH 25/40] parisc: Use set_current_blocked() and
 block_sigmask()
Message-ID: <20120406145915.GC15318@bombadil.infradead.org>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
 <1329219673-28711-26-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329219673-28711-26-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 11:40:58AM +0000, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> As described in e6fa16ab ("signal: sigprocmask() should do
> retarget_shared_pending()") the modification of current->blocked is
> incorrect as we need to check whether the signal we're about to block
> is pending in the shared queue.
> 
> Also, use the new helper function introduced in commit 5e6292c0f28f
> ("signal: add block_sigmask() for adding sigmask to current->blocked")
> which centralises the code for updating current->blocked after
> successfully delivering a signal and reduces the amount of duplicate
> code across architectures. In the past some architectures got this
> code wrong, so using this helper function should stop that from
> happening again.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Cc: Helge Deller <deller@gmx.de>
> Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> Cc: linux-parisc@vger.kernel.org
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>

Nice cleanups Matt!

Acked-by: Kyle McMartin <kyle@mcmartin.ca>
