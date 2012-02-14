Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970Ab2BNJcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:32:33 -0500
Received: from db3outboundsmtppool1.messaging.microsoft.com ([94.245.120.123]:56096
	"EHLO DB3EHSNDR002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759652Ab2BNJc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:32:29 -0500
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: 0
X-BigFish: VS0(zz98dKzz1202h1082kzzz2dh87h2a8h668h839h944h41h42h)
X-Forefront-Antispam-Report: CIP:94.101.220.16;KIP:(null);UIP:(null);IPV:NLI;H:nzt0014e.dknz.nzcorp.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 14 Feb 2012 10:32:21 +0100
From: Anders Ossowicki <aowi@novozymes.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: Memory issues with Opteron 6220
Message-ID: <20120214093221.GA8363@otto.nzcorp.net>
Reply-To: <aowi@novozymes.com>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <20120208143741.GB28486@otto.nzcorp.net>
 <20120209083315.GA19380@elte.hu>
 <4F343582.7080007@krogh.cc>
 <4F3535E7.4000007@krogh.cc>
 <20120211134847.GD28098@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120211134847.GD28098@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SMTP-Mail-From: aowi@otto.nzcorp.net
X-OriginatorOrg: novozymes.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 11, 2012 at 02:48:47PM +0100, Ingo Molnar wrote:
> It would be helpful if you could enhance the printk in such a 
> way, and if you tested it with your workload that triggers it - 
> and send us the resulting patch. Having more information in the 
> dmesg is never bad.
I'd be happy to do so, but I'm not sure where the appropriate place to add it
is.  I'm guessing a printk wrapped in a printk_ratelimit somewhere in mm but I
know next to nothing about the internals of the kernel.
-- 
Anders Ossowicki

