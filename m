Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277Ab0E0VZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:25:29 -0400
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:43813 "EHLO
	homiemail-a15.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753154Ab0E0VZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:25:27 -0400
X-Greylist: delayed 11978 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2010 17:25:27 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=sysclose.org; h=date:from:to:cc
	:subject:message-id:references:mime-version:content-type:
	in-reply-to; q=dns; s=sysclose.org; b=Vwg24bRpBpZKBlH+Ca1guOb9LT
	qEDOtQ72C6kKOUBVsRV+zjyhrdfSikknBASFli9vCP2Gxk75mUrk8WgDFq/FvR+5
	ckvo4TWXehStqN3YiDIckTAWV0f2hTC2ddc+aONKZzJtyemvom8JTMxwoMo+kqML
	wyFD4qQTQTwc97whQ=
Date: Thu, 27 May 2010 18:25:23 -0300
From: Flavio Leitner <fbl@sysclose.org>
To: David Miller <davem@davemloft.net>
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, mpm@selenic.com,
       netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
       gospo@redhat.com, nhorman@tuxdriver.com, jmoyer@redhat.com,
       shemminger@linux-foundation.org, bonding-devel@lists.sourceforge.net,
       fubar@us.ibm.com
Subject: Re: [v5 Patch 1/3] netpoll: add generic support for bridge and
 bonding devices
Message-ID: <20100527212523.GB2345@sysclose.org>
References: <20100505081514.5157.83783.sendpatchset@localhost.localdomain>
 <20100527180545.GA2345@sysclose.org>
 <20100527.133559.193700421.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527.133559.193700421.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 01:35:59PM -0700, David Miller wrote:
> From: Flavio Leitner <fbl@sysclose.org>
> Date: Thu, 27 May 2010 15:05:45 -0300
> 
> > I did the following patch to discard the packet if it was IN_NETPOLL
> > and the read_lock() fails, so I could go ahead testing it:
> 
> This is disgusting, let's just disallow console output from such
> locations.  Defer them to a workqueue if their output is so critical.

I did that patch just to see the backtrace in the serial console
and to keep testing it. It's not a solution at all.

Just to be clear, the second problem isn't related to that patch
and the console message is already in a workqueue.

-- 
Flavio
