Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab2EHC32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 22:29:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53593 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab2EHC30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 22:29:26 -0400
Date: Mon, 07 May 2012 22:29:12 -0400 (EDT)
Message-Id: <20120507.222912.1594023027707777260.davem@davemloft.net>
To: tilman@imap.cc
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, hjlipp@web.de,
        keil@b1-systems.de, i4ldeveloper@listserv.isdn4linux.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] ISDN patches for net-next
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FA867B1.9080003@imap.cc>
References: <20120425-patch-gigaset-00.tilman@imap.cc>
	<4FA867B1.9080003@imap.cc>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 07 May 2012 19:29:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Tue, 08 May 2012 02:24:17 +0200

> On 26.04.2012 01:02, /me wrote:
>> here's a series of eight patches to the Kernel CAPI subsystem and
>> the Gigaset driver. Please consider for application to net-next.
>> The first three should also go into -stable and are tagged accordingly.
> 
> Is there anything missing for these to be accepted into net-next?
> Or should I just be patient?

I'll take care of it, I just put them back into "under review" state
in patchwork.
