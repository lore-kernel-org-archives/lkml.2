Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab1AKUwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 15:52:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52593
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441Ab1AKUwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 15:52:22 -0500
Date: Tue, 11 Jan 2011 12:52:54 -0800 (PST)
Message-Id: <20110111.125254.133402589.davem@davemloft.net>
To: stefani@seibold.net
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        shemminger@vyatta.com, jj@chaosbits.net, daniel.baluta@gmail.com,
        jochen@jochen.org, hagen@jauu.net, torvalds@linux-foundation.org,
        pavel@ucw.cz
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: David Miller <davem@davemloft.net>
In-Reply-To: <1294779020.16410.2.camel@wall-e>
References: <1294764515-15356-1-git-send-email-stefani@seibold.net>
	<1294765273.2927.65.camel@edumazet-laptop>
	<1294779020.16410.2.camel@wall-e>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>
Date: Tue, 11 Jan 2011 21:50:20 +0100

> Right, but currently there is no need for an IPV6 implementation, non of
> our base station provide it and non of our mobile network customers use
> it.
> 
> If it will be required in the future it will be implemented.

We require that you implement the ipv6 side for the submission right
now.

Long gone are the days when we add ipv4 only implementations of
protocols.
