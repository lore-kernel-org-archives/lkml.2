Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab0GFCXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:23:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36207
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839Ab0GFCXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:23:42 -0400
Date: Mon, 05 Jul 2010 19:23:56 -0700 (PDT)
Message-Id: <20100705.192356.52184135.davem@davemloft.net>
To: tilman@imap.cc
Cc: isdn@linux-pingi.de, hjlipp@web.de, keil@b1-systems.de,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11] isdn/gigaset: improve CAPI message debugging
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100705-patch-gigaset-05.tilman@imap.cc>
References: <20100705-patch-gigaset-00.tilman@imap.cc>
	<20100705-patch-gigaset-05.tilman@imap.cc>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Tue,  6 Jul 2010 02:18:59 +0200 (CEST)

> @@ -384,7 +388,7 @@ void gigaset_skb_sent(struct bc_state *bcs, struct sk_buff *dskb)
>  
>  	/* don't send further B3 messages if disconnected */
>  	if (bcs->apconnstate < APCONN_ACTIVE) {
> -		gig_dbg(DEBUG_LLDATA, "disconnected, discarding ack");
> +		gig_dbg(DEBUG_MCMD, "disconnected, discarding ack");
>  		return;
>  	}

This is against something other than net-next-2.6 even with your
other two ISDN patches applied, because all of these lines read
"if (ap->connected ..."

Please tell me what exactly these patches are against so that I
can apply them to net-next-2.6 cleanly.
