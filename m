Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab0DJWsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 18:48:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43604
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354Ab0DJWsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 18:48:53 -0400
Date: Sat, 10 Apr 2010 15:48:56 -0700 (PDT)
Message-Id: <20100410.154856.54433341.davem@davemloft.net>
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
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 10 Apr 2010 11:47:31 +0200

> Could you give us your compiler version ?
> 
> Code is fine, but compiler a bit dumb :(

Build failures happen all over the kernel with that
USER_COPY_CHECK config option enabled, it's not really
a bug report and I've even told people like Stephen
Rothwell to do their allmodconfig builds on platforms
like sparc64 with this option hard disabled.
