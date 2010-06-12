Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab0FLV61 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 17:58:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58994
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589Ab0FLV60 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 17:58:26 -0400
Date: Sat, 12 Jun 2010 14:58:35 -0700 (PDT)
Message-Id: <20100612.145835.123986343.davem@davemloft.net>
To: markus@trippelsdorf.de
Cc: john.r.fastabend@intel.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: mpd client timeouts (bisected) 2.6.35-rc3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100612102802.GA1782@arch.tripp.de>
References: <20100612102802.GA1782@arch.tripp.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Trippelsdorf <markus@trippelsdorf.de>
Date: Sat, 12 Jun 2010 12:28:02 +0200

> Commit 597a264b1a9c7e36d1728f677c66c5c1f7e3b837:
> »net: deliver skbs on inactive slaves to exact matches«
> 
> causes large timeouts when mpd clients try to connect to a locally
> running mpd (music player demon) on my machine. This makes it 
> impossible to control mpd.
> 
> I bisected this down to the commit mentioned above.
> Reverting the commit from 2.6.35-rc3 also solves the problem.

John, find an easy and fast way to fix this or else I am
going to revert.

Thanks.
