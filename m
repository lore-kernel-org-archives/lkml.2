Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab1ASMqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:46:49 -0500
Received: from mail.solarflare.com ([216.237.3.220]:32668 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab1ASMqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:46:47 -0500
Subject: Re: [PATCH v2] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Ben Hutchings <bhutchings@solarflare.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: Joe Perches <joe@perches.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ratbert@faraday-tech.com,
        eric.dumazet@gmail.com, dilinger@queued.net
In-Reply-To: <AANLkTi=nJxwR89CF3i0+L6+yM4Bg_PN8PQByTAHP2nPM@mail.gmail.com>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com>
	 <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
	 <1295284788.21277.65.camel@Joe-Laptop>
	 <AANLkTi=nJxwR89CF3i0+L6+yM4Bg_PN8PQByTAHP2nPM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 19 Jan 2011 12:46:40 +0000
Message-ID: <1295441200.2906.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2011 12:46:46.0944 (UTC) FILETIME=[EEEACA00:01CBB7D6]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17902.005
X-TM-AS-Result: No--4.290100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 17:40 +0800, Po-Yu Chuang wrote:
[...]
> Well, TBH, I don't like this style because if I changed the
> function name, the indentation might need to be adjusted.
> 
> Even worse, I got an infeasible case :-(
> 
> static struct ftmac100_rxdes *ftmac100_rx_locate_first_segment(
> 							       struct ftmac100 *priv)
> 
> I know my function names are quite long, but I like them to be descriptive.
> Do you really insist on it?

You can break after the return type:

static struct ftmac100_rxdes *
ftmac100_rx_locate_first_segment(struct ftmac100 *priv)

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

