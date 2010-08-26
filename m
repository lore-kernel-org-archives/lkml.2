Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab0HZMHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 08:07:34 -0400
Received: from mail.solarflare.com ([216.237.3.220]:17479 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0HZMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 08:07:31 -0400
Subject: Re: [PATCH] tcp: select(writefds) don't hang up when a peer close
 connection
From: Ben Hutchings <bhutchings@solarflare.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
In-Reply-To: <20100826125357.F667.A69D9226@jp.fujitsu.com>
References: <20100825.153424.246521475.davem@davemloft.net>
	 <1282785886.22839.199.camel@localhost>
	 <20100826125357.F667.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Thu, 26 Aug 2010 13:07:28 +0100
Message-ID: <1282824448.2263.3.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Aug 2010 12:11:12.0905 (UTC) FILETIME=[C69EC790:01CB4517]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17596.004
X-TM-AS-Result: No--17.319800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 12:55 +0900, KOSAKI Motohiro wrote:
[...]
> Cool!
> 
> Ben, I think your code is cleaner than mine. If you allow me, I hope to
> include this one into my patch description.

You can do that if you like, but it seems a bit long for a commit
message.

By the way, I was able to reproduce this bug in RHEL 3 (kernel based on
2.4.21) so it seems to have been around for a while.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

