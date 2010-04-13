Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab0DMKJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 06:09:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49666
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008Ab0DMKJ0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 06:09:26 -0400
Date: Tue, 13 Apr 2010 03:09:30 -0700 (PDT)
Message-Id: <20100413.030930.106805212.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: nm127@freemail.hu, socketcan@hartkopp.net, oliver.hartkopp@volkswagen.de,
       urs.thuermann@volkswagen.de, socketcan-core@lists.berlios.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.34-rc3 + CAN build problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <1270892851.2093.32.camel@edumazet-laptop>
References: <4BC03340.5020500@freemail.hu>
	<1270892851.2093.32.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 10 Apr 2010 11:47:31 +0200

> [PATCH] can: avoids a false warning
> 
> At this point optlen == sizeof(sfilter) but some compilers are dumb.
> 
> Reported-by: Németh Márton <nm127@freemail.h
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks Eric.
