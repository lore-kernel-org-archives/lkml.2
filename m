Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0EWAnO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 20:43:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35585
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755587Ab0EWAnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 20:43:12 -0400
Date: Sat, 22 May 2010 17:43:18 -0700 (PDT)
Message-Id: <20100522.174318.197930599.davem@davemloft.net>
To: tilman@imap.cc
Cc: isdn@linux-pingi.de, hjlipp@web.de, keil@b1-systems.de,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] ISDN patches for 2.6.35
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100522-patch-gigaset-00.tilman@imap.cc>
References: <20100522-patch-gigaset-00.tilman@imap.cc>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Sun, 23 May 2010 02:24:12 +0200 (CEST)

> Karsten, David,
> 
> following are seven patches to the CAPI subsystem and the Gigaset
> driver I'd like to see included in kernel release 2.6.35.
> The first three respond to user reports about an observed hang of
> the userspace command "capiinit stop".
> The others are cleanups from the ongoing driver development.

What the heck about "no more cleanups or new features for networking"
do you not understand?

When the merge window is openned, this is not a signal to you to send
changes to me.  You should have stuff in weeks ahead of that time.

I'm willing to take bug fixes only at this point so you'll need to
respin this series.

And Tilman, of all people you really should know better.
