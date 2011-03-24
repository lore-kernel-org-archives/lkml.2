Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab1CXVpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:45:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32770
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756Ab1CXVpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:45:50 -0400
Date: Thu, 24 Mar 2011 14:46:28 -0700 (PDT)
Message-Id: <20110324.144628.58411809.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: serge.hallyn@ubuntu.com, bhutchings@solarflare.com, eparis@redhat.com,
        eparis@parisplace.org, segoon@openwall.com,
        linux-kernel@vger.kernel.org, mjt@tls.msk.ru, arnd@arndb.de,
        mirqus@gmail.com, netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, eric.dumazet@gmail.com, therbert@google.com,
        xiaosuo@gmail.com, jesse@nicira.com, kees.cook@canonical.com,
        eugene@redhat.com, dan.j.rosenberg@gmail.com,
        akpm@linux-foundation.org, greg@kroah.com, sds@tycho.nsa.gov,
        linux-security-module@vger.kernel.org, dwalsh@redhat.com,
        dhowells@redhat.com
Subject: Re: [PATCH v2] net: don't allow CAP_NET_ADMIN to load non-netdev
 kernel modules
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110324143944.29f4c362@nehalam>
References: <1300991584.2689.35.camel@bwh-desktop>
	<20110324202634.GB9191@peq.hallyn.com>
	<20110324143944.29f4c362@nehalam>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Thu, 24 Mar 2011 14:39:44 -0700

> This breaks for many of the tunneling protocols, that rely on
> autoload for names like "sit0"

Frankly I'm very disappointed in the fallout this has been causing.

Everyone supporting this change, get real, and admit it doing in fact
cause a serious regression.

If you can't get past that simple fact, you cannot discuss this issue
intelligently.

You can't say "userland will fix things up"

Because we're never supposed to break userland in the first place.

There is simply no excuse for this and I want this change reverted
both in Linus's tree and in -stable.
