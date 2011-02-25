Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab1BYTPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:15:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43496
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932605Ab1BYTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:15:30 -0500
Date: Fri, 25 Feb 2011 11:16:06 -0800 (PST)
Message-Id: <20110225.111606.115927805.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: segoon@openwall.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, eric.dumazet@gmail.com,
        therbert@google.com, xiaosuo@gmail.com, jesse@nicira.com,
        kees.cook@canonical.com, eugene@redhat.com, dan.j.rosenberg@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] don't allow CAP_NET_ADMIN to load non-netdev kernel
 modules
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298660879.2554.23.camel@bwh-desktop>
References: <20110225190205.GA4541@albatros>
	<20110225.110529.39178636.davem@davemloft.net>
	<1298660879.2554.23.camel@bwh-desktop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Fri, 25 Feb 2011 19:07:59 +0000

> You realise that module loading doesn't actually run in the context of
> request_module(), right?

Why is that a barrier?  We could simply pass a capability mask into
request_module if necessary.

It's an implementation detail, and not a deterrant to my suggested
scheme.
