Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab0JZTTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:19:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42283
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755976Ab0JZTTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:19:18 -0400
Date: Tue, 26 Oct 2010 12:19:41 -0700 (PDT)
Message-Id: <20101026.121941.98879640.davem@davemloft.net>
To: gwurster@scs.carleton.ca
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, shemminger@vyatta.com,
        eric.dumazet@gmail.com, herbert@gondor.hengli.com.au,
        ebiederm@xmission.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-2.6 v2] IPv6: Temp addresses are immediately
 deleted.
From: David Miller <davem@davemloft.net>
In-Reply-To: <201010161442.18748.gwurster@scs.carleton.ca>
References: <20100927171010.GB7106@adams.ccsl.carleton.ca>
	<20100928.233028.112599117.davem@davemloft.net>
	<201010161442.18748.gwurster@scs.carleton.ca>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glenn Wurster <gwurster@scs.carleton.ca>
Date: Sat, 16 Oct 2010 14:42:17 -0400

> This patch accommodates the case where the router is only broadcasting 
> advertisements every x seconds, and yet the user has set the valid_lft to be 
> something less than x.  In this setup, the condition I mentioned in the patch 
> description happens, where the new temporary address is created, but the last 
> modification time on that temporary address is set to the time of the last 
> router advertisement, which was more than valid_lft seconds ago.  In this 
> case, the temporary address is immediately deleted, and we are left with no 
> temporary address on the interface.  Furthermore, because all temporary 
> addresses get deleted by the time the next router advertisement arrives, we 
> are left with not being able to use temporary addresses until we move 
> networks.

Thanks for the information, I'll look into this some more.
