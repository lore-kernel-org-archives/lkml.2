Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936529Ab0COOax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:30:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:49223 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932644Ab0COOaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:30:52 -0400
Date: Mon, 15 Mar 2010 07:27:51 -0700
From: Greg KH <gregkh@suse.de>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 120/123] sched: Fix sched_mv_power_savings for !SMT
Message-ID: <20100315142751.GA5690@suse.de>
References: <20100313001618.GA9811@kroah.com> <20100313001515.642272234@kvm.kroah.org> <20100315055118.GP5212@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315055118.GP5212@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 11:21:18AM +0530, Vaidyanathan Srinivasan wrote:
> * Greg KH <gregkh@suse.de> [2010-03-12 16:13:38]:
> 
> > 2.6.33-stable review patch.  If anyone has any objections, please let me know.
> 
> Hi Greg,
> 
> Thanks to pulling this into .32 and .33-stable.  Please correct the
> subject and commit message to sched_mc_power_savings when you apply.
> The term sched_mv_power_savings is a typo.
> 
> "sched: Fix sched_mc_power_savings for !SMT"

I'd prefer to leave it as-is as that is what the subject is in Linus's
tree.

thanks,

greg k-h
