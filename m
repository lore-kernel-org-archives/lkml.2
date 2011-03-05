Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1CEMbG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 07:31:06 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:6243 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab1CEMbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 07:31:05 -0500
Subject: Re: [PATCH] net: mac80211: fix compilation warning
From: Ben Hutchings <bhutchings@solarflare.com>
To: bookjovi@gmail.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING [WIREL..." <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <1299108754-5492-1-git-send-email-bookjovi@gmail.com>
References: <1299108754-5492-1-git-send-email-bookjovi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Sat, 05 Mar 2011 12:31:00 +0000
Message-ID: <1299328260.4277.92.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2011 12:31:04.0587 (UTC) FILETIME=[31D145B0:01CBDB31]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17992.005
X-TM-AS-Result: No--14.126600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 18:32 -0500, bookjovi@gmail.com wrote:
> From: Jovi Zhang <bookjovi@gmail.com>
> 
> this commit fix compilation warning as following:
> net/mac80211/tx.c:1753: warning: unused variable mppath
[...]

You clearly didn't try building this with CONFIG_MAC80211_MESH enabled.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

