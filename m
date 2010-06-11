Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab0FKUiC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:38:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50335
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290Ab0FKUiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:38:00 -0400
Date: Fri, 11 Jun 2010 13:38:11 -0700 (PDT)
Message-Id: <20100611.133811.52184181.davem@davemloft.net>
To: dvomlehn@cisco.com
Cc: to@dvomlehn-lnx2.corp.sa.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4][RFC] Introduction to sk_buff state checking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100611203350.GA28383@dvomlehn-lnx2.corp.sa.net>
References: <20100611203350.GA28383@dvomlehn-lnx2.corp.sa.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the second time you've submitted this patch set,
it is also the second time that:

1) Your email client has emitted these strange
   "linux-kernel@vger.kernel.org"@cisco.com
   addresses.

   I saw that you were specifically notified about this
   problem during the previous submission.

   What did you do to try and correct it?

2) You are not CC:'ing the networking developer mailing
   list "netdev@vger.kernel.org"  Many networking developers
   do not read linux-kernel, so by not CC:'ing that list
   you are not reaching the folks most capable of reviewing
   your patches.

Please fix this up.
