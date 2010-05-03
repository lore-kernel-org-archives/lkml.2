Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0ECFzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 01:55:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51358
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754454Ab0ECFzD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 01:55:03 -0400
Date: Sun, 02 May 2010 22:55:09 -0700 (PDT)
Message-Id: <20100502.225509.233880079.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org, peterz@infradead.org,
       kaber@trash.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: mmotm 2010-04-28 - RCU whinges
From: David Miller <davem@davemloft.net>
In-Reply-To: <1272865436.2173.182.camel@edumazet-laptop>
References: <1272865137.2173.179.camel@edumazet-laptop>
	<1272865267.2173.180.camel@edumazet-laptop>
	<1272865436.2173.182.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 03 May 2010 07:43:56 +0200

> Le lundi 03 mai 2010 à 07:41 +0200, Eric Dumazet a écrit :
> 
>> Oops scratch that, I'll resend a correct version.
>> 
>> 
> 
> Sorry, patch _is_ fine, I had one brain collapse when re-reading it, I
> thought a different mutex was in use in one of the functions.

Ok, Patrick please review, thanks.
