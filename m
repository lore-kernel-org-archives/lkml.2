Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab0JDT0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 15:26:42 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:44220 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab0JDT0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 15:26:41 -0400
X-Originating-Ip: 216.16.235.2
Date: Mon, 4 Oct 2010 15:26:31 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] um: rcu_sched_state detected stall on CPU 0
Message-ID: <20101004192631.GA30065@foursquare.net>
References: <AANLkTimmwViVHMy-7S3N9Ps1Vj_n_TfJLvwzoupsFPnp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimmwViVHMy-7S3N9Ps1Vj_n_TfJLvwzoupsFPnp@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 12:03:04AM +0200, richard -rw- weinberger wrote:
> Hi,
> 
> I'm seeing often messages like this one on my UML:
> ...
> INFO: rcu_sched_state detected stall on CPU 0 (t=7348 jiffies)
> ...
> 
> The system often seems to be frozen.
> When I press a button it wakes up immediately and continues to run.
> 
> Any ideas?
> Config is attached.

I saw this too, but I thought it was because I was overloading my machine.
I only seem to see it when the guest is starved for CPU due to IO on the
host.

- Chris

