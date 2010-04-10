Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab0DJWuI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 18:50:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43613
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356Ab0DJWuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 18:50:05 -0400
Date: Sat, 10 Apr 2010 15:50:09 -0700 (PDT)
Message-Id: <20100410.155009.66184583.davem@davemloft.net>
To: socketcan@hartkopp.net
Cc: nm127@freemail.hu, eric.dumazet@gmail.com, oliver.hartkopp@volkswagen.de,
       urs.thuermann@volkswagen.de, socketcan-core@lists.berlios.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.34-rc3 + CAN build problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BC070E0.6070601@hartkopp.net>
References: <1270892851.2093.32.camel@edumazet-laptop>
	<4BC054AE.7040303@freemail.hu>
	<4BC070E0.6070601@hartkopp.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Sat, 10 Apr 2010 14:36:48 +0200

> So i wonder why Nemeth trapped into this problem ... probably an include file
> mix-up?

Do you have CONFIG_DEBUG_STRICT_USER_COPY_CHECKS enabled in your
kernel config?

That's the only way you get an actual failure of a build when
the user copy size can't be proven to be in range by the
compiler, otherwise it just warns.
