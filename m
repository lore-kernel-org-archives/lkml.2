Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab0JZTic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:38:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33381
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865Ab0JZTi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:38:29 -0400
Date: Tue, 26 Oct 2010 12:38:52 -0700 (PDT)
Message-Id: <20101026.123852.58436932.davem@davemloft.net>
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

> No, the first patch was to create a temporary address if none exists.  Like 
> Brian Haley pointed out, that patch accommodates the case where we set 
> use_tempaddr to a non-zero value after the interface had been brought up.
> 
> This patch accommodates the case where the router is only broadcasting 
> advertisements every x seconds, and yet the user has set the valid_lft to be 
> something less than x.

Ok, thanks for your patience.

I've applied both of your patches, thanks.
