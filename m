Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab2DLAKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:10:09 -0400
Received: from mail.vyatta.com ([76.74.103.46]:54572 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab2DLAKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:10:07 -0400
Date: Wed, 11 Apr 2012 17:10:04 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: paulmck@linux.vnet.ibm.com
Cc: Meelis Roos <mroos@linux.ee>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: suspicious RCU usage warnings in 3.3.0
Message-ID: <20120411171004.016ddd95@nehalam.linuxnetplumber.net>
In-Reply-To: <20120411230837.GC2473@linux.vnet.ibm.com>
References: <alpine.SOC.1.00.1203281134090.13691@math.ut.ee>
	<20120328.174559.650861844028495880.davem@davemloft.net>
	<alpine.SOC.1.00.1204111807420.26884@math.ut.ee>
	<20120411230837.GC2473@linux.vnet.ibm.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012 16:08:37 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> Hmmm...  What CPU family is this running on?  From the look of the
> stack, it is sneaking out of idle into softirq without telling RCU.
> This would cause RCU to complain bitterly about being invoked from
> the idle loop -- and RCU ignores CPUs in the idle loop.
> 
> 							Thanx, Paul

Sun4... Ping David.
