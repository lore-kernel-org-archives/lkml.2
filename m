Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab1K2FWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 00:22:33 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60519 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1K2FWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 00:22:32 -0500
X-Originating-IP: 217.70.178.139
X-Originating-IP: 50.43.15.19
Date: Mon, 28 Nov 2011 21:22:25 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] rcu: Make new RCU dynticks API work with nohz cpusets
Message-ID: <20111129052225.GB14546@leaf>
References: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 10:24:43PM +0100, Frederic Weisbecker wrote:
> Hi Paul,
> 
> This is an attempt to make the current RCU dynticks API
> working with the nohz cpusets.
> 
> I believe the two first patches could be pushed in your trees.
> Patches 3 and 4 are rather something I plan to apply in mine,
> given they are not needed upstream yet.
> 
> Waiting for your comments.
> 
> Thanks.
> 
> Frederic Weisbecker (4):
>   rcu: Don't check irq nesting from rcu idle entry/exit
>   rcu: Irq nesting is always 0 on rcu_enter_idle_common
>   rcu: New rcu_user_enter() and rcu_user_exit() APIs
>   rcu: New rcu_user_enter_irq() and rcu_user_exit_irq() APIs

For the whole series:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
