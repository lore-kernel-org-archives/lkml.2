Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2CDAKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 19:10:48 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:31117 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753273Ab2CDAKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 19:10:47 -0500
Message-ID: <1330819855.8460.291.camel@deadeye>
Subject: Re: How do I know my driver support RSS?
From: Ben Hutchings <bhutchings@solarflare.com>
To: Yuehai Xu <yuehaixu@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, <yhxu@wayne.edu>, <sbw@mit.edu>
Date: Sun, 4 Mar 2012 00:10:55 +0000
In-Reply-To: <CAEc1PS1j2DL4m7B1Rp9nseqLWsxaXXY+ZJDHra+99c5-WPgYcQ@mail.gmail.com>
References: <CAEc1PS1j2DL4m7B1Rp9nseqLWsxaXXY+ZJDHra+99c5-WPgYcQ@mail.gmail.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [78.32.9.209]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18748.005
X-TM-AS-Result: No--18.232200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-03 at 16:25 -0500, Yuehai Xu wrote:
[...]
> Since I read the following statements from a paper, "we use a separate
> hardware receive and transmit queue for each core and configure the
> IXGBE to inspect the port number in each incoming packet header, place
> the packet on the queue dedicated to the associated memcached's core,
> and deliver the receive interrupt to that core." and the background of
> this configuration is that each memcached is pinned to a separate core
> and has its own UDP port. It seems that IXGBE's driver can detect UDP
> packets according to their port numbers and put these packets into
> corresponding receive queues in the hardware, is this achieved by
> configuring RSS in IXGBE? If it is, I am wondering whether bnx2
> supports RSS and whether it can configure in the same way.
> 
> I appreciate any help for this.

You're confusing RSS (flow hashing) with flow steering.  These are both
explained in Documentation/network/scaling.txt.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

