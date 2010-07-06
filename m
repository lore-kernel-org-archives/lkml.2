Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0GFByy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 21:54:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36453
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699Ab0GFByx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 21:54:53 -0400
Date: Mon, 05 Jul 2010 18:55:07 -0700 (PDT)
Message-Id: <20100705.185507.59671874.davem@davemloft.net>
To: tilman@imap.cc
Cc: isdn@linux-pingi.de, hjlipp@web.de, keil@b1-systems.de,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] ISDN patches for 2.6.36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100705.185352.39176355.davem@davemloft.net>
References: <20100705-patch-gigaset-00.tilman@imap.cc>
	<20100705.185352.39176355.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 05 Jul 2010 18:53:52 -0700 (PDT)

> From: Tilman Schmidt <tilman@imap.cc>
> Date: Tue,  6 Jul 2010 02:18:32 +0200 (CEST)
> 
>> Karsten, David,
>> 
>> following are a series of patches to the Gigaset driver I'd like
>> to see included in kernel release 2.6.36.
> 
> Do they have any dependencies on the two patch set of fixes
> you just sent out for net-2.6?
                        ^^^^^^^

Of course I meant net-next-2.6

> You must always let me know this so I don't go blindly trying
> to apply your patches onto to find that they don't apply cleanly
> because of a dependency you have failed to mention.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
