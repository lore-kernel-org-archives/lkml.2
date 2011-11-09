Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab1KIXnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 18:43:45 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:16263 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab1KIXno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 18:43:44 -0500
Subject: Re: [PATCH net-next v1 5/9] forcedeth: implement ndo_get_stats64()
 API
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <david.decotigny@google.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
In-Reply-To: <14be343e242ede786e387b1d22f0a9259ec7d862.1320875577.git.david.decotigny@google.com>
References: <cover.1320875577.git.david.decotigny@google.com>
	 <14be343e242ede786e387b1d22f0a9259ec7d862.1320875577.git.david.decotigny@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 9 Nov 2011 23:43:38 +0000
Message-ID: <1320882218.2781.22.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18502.005
X-TM-AS-Result: No--3.152100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 09 Nov 2011 23:43:43.0475 (UTC) FILETIME=[6A729C30:01CC9F39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 14:09 -0800, David Decotigny wrote:
> This commit implements the ndo_get_stats64() API for forcedeth. Since
> these stats are being updated from different contexts (process and
> timer), this commit adds protection (locking + atomic variables).
[...]

I don't claim to have reviewed this properly, but it looks reasonable.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

