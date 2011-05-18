Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1ERU0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:26:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49771 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab1ERU0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:26:52 -0400
Date: Wed, 18 May 2011 16:23:06 -0400 (EDT)
Message-Id: <20110518.162306.441229167098643303.davem@davemloft.net>
To: hagen@jauu.net
Cc: tsunanet@gmail.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110518202025.GC4175@nuttenaction>
References: <BANLkTik-6wh8=jb6oMEpJvYC8+KTGGsMsw@mail.gmail.com>
	<20110518.155200.801089483916944725.davem@davemloft.net>
	<20110518202025.GC4175@nuttenaction>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 May 2011 13:23:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hagen Paul Pfeifer <hagen@jauu.net>
Date: Wed, 18 May 2011 22:20:25 +0200

> I like the idea to make the initial RTO a knob because we in a
> isolated MANET environment have a RTT larger then 1 second.

Then this gets back to the fact that this is a network
attribute and thus more suitable as a route metric not
a global system-wide sysctl.
