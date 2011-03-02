Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1CBHPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:15:13 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:57497 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702Ab1CBHPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:15:12 -0500
Message-ID: <4D6DEE7C.6020700@msgid.tls.msk.ru>
Date: Wed, 02 Mar 2011 10:15:08 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, mirqus@gmail.com,
        netdev@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, eric.dumazet@gmail.com, therbert@google.com,
        xiaosuo@gmail.com, jesse@nicira.com, kees.cook@canonical.com,
        eugene@redhat.com, dan.j.rosenberg@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] net: don't allow CAP_NET_ADMIN to load non-netdev
 kernel modules
References: <201102272122.52643.arnd@arndb.de> <4D6B6AE7.2050202@msgid.tls.msk.ru> <20110228095133.GA4351@albatros> <20110228.112349.104067277.davem@davemloft.net> <20110301194845.GA3533@albatros> <1299010390.2529.30.camel@bwh-desktop> <20110301213313.GA6507@albatros>
In-Reply-To: <20110301213313.GA6507@albatros>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02.03.2011 00:33, Vasiliy Kulikov wrote:
> Since a8f80e8ff94ecba629542d9b4b5f5a8ee3eb565c any process with
> CAP_NET_ADMIN may load any module from /lib/modules/.  This doesn't mean
> that CAP_NET_ADMIN is a superset of CAP_SYS_MODULE as modules are
> limited to /lib/modules/**.  However, CAP_NET_ADMIN capability shouldn't
> allow anybody load any module not related to networking.
> 
> This patch restricts an ability of autoloading modules to netdev modules
> with explicit aliases.  This fixes CVE-2011-1019.
[]
> Reference: https://lkml.org/lkml/2011/2/24/203
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

This looks much saner :)

Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>

/mjt
