Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1BARHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:07:20 -0500
Received: from smtp-gw11.han.skanova.net ([81.236.55.20]:52019 "EHLO
	smtp-gw11.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab1BARHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:07:18 -0500
MIME-Version: 1.0
X-Mailer: AfterLogic WebMail PHP
X-Originating-IP: 194.237.142.5
X-Priority: 3 (Normal)
Message-ID: <7j2t3lt.8dc16aed303bfc25a870d65e413a99d5@obelix.schillstrom.com>
From: "Hans Schillstrom" <hans@schillstrom.com>
To: "Simon Horman" <horms@verge.net.au>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "Patrick McHardy" <kaber@trash.net>
Subject: Re: [PATCH 3/5] IPVS: Remove unused variables
Date: Tue, 1 Feb 2011 18:07:10 +0100 (CET)
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>---- Original Message ----
>From: Simon Horman <horms@verge.net.au>
>To: netdev@vger.kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org
>Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, "Stephen Rothwell" <sfr@canb.auug.org.au>, "Hans Schillstrom" <hans@schillstrom.com>, "Patrick McHardy" <kaber@trash.net>, "Simon Horman" <horms@verge.net.au>
>Sent: Tue, Feb 1, 2011, 11:11 AM
>Subject: [PATCH 3/5] IPVS: Remove unused variables
>
>These variables are unused as a result of the recent netns work.
>
>Cc: Hans Schillstrom <hans@schillstrom.com>
>Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Hans Schillstrom <hans@schillstrom.com>
Tested-by: Hans Schillstrom <hans@schillstrom.com>

>---
> include/net/ip_vs.h |    2 --
> 1 files changed, 0 insertions(+), 2 deletions(-)
>
>diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
>index b23bea6..5d75fea 100644
>--- a/include/net/ip_vs.h
>+++ b/include/net/ip_vs.h
>@@ -1109,8 +1109,6 @@ extern int ip_vs_icmp_xmit_v6
>  *	we are loaded. Just set ip_vs_drop_rate to 'n' and
>  *	we start to drop 1/rate of the packets
>  */
>-extern int ip_vs_drop_rate;
>-extern int ip_vs_drop_counter;
> 
> static inline int ip_vs_todrop(struct netns_ipvs *ipvs)
> {
>-- 
>1.7.2.3
>
>--
>To unsubscribe from this list: send the line "unsubscribe lvs-devel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

