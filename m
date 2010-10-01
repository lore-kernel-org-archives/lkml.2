Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab0JAAmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 20:42:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33317
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632Ab0JAAme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 20:42:34 -0400
Date: Thu, 30 Sep 2010 17:42:54 -0700 (PDT)
Message-Id: <20100930.174254.184831800.davem@davemloft.net>
To: brian.haley@hp.com
Cc: gwurster@scs.carleton.ca, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        shemminger@vyatta.com, eric.dumazet@gmail.com,
        herbert@gondor.hengli.com.au, ebiederm@xmission.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-2.6 v2] IPv6: Create temporary address if none
 exists.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CA35084.8010503@hp.com>
References: <20100927170430.GA7106@adams.ccsl.carleton.ca>
	<20100928.222510.71109554.davem@davemloft.net>
	<4CA35084.8010503@hp.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Haley <brian.haley@hp.com>
Date: Wed, 29 Sep 2010 10:43:16 -0400

> From what I have found, this is fixing the case where we've changed
> use_tempaddr to 1 on an interface that already has a "stable" IPv6
> prefix.  In that case you'll never add a temporary address:

We should have enough information to instantiate the temporary address
when the syscal value is enabled.  So I would prefer if we fixed it
that way.
