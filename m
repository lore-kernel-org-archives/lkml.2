Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093Ab1EMVbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:31:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:49698 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758325Ab1EMVbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 17:31:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,366,1301900400"; 
   d="scan'208";a="746998236"
From: Andi Kleen <andi@firstfloor.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: David Miller <davem@davemloft.net>, solar@openwall.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peak@argo.troja.mff.cuni.cz, kees.cook@canonical.com,
        dan.j.rosenberg@gmail.com, eugene@redhat.com, nelhage@ksplice.com,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, linux-man@vger.kernel.org
Subject: Re: [PATCH v3] net: ipv4: add IPPROTO_ICMP socket kind
References: <20110510.121550.112583080.davem@davemloft.net>
	<20110513200100.GA3875@albatros>
Date: Fri, 13 May 2011 14:30:43 -0700
In-Reply-To: <20110513200100.GA3875@albatros> (Vasiliy Kulikov's message of
	"Sat, 14 May 2011 00:01:00 +0400")
Message-ID: <m2wrhuxp8c.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasiliy Kulikov <segoon@openwall.com> writes:

> This patch adds IPPROTO_ICMP socket kind.  It makes it possible to send
> ICMP_ECHO messages and receive the corresponding ICMP_ECHOREPLY messages
> without any special privileges.  In other words, the patch makes it
> possible to implement setuid-less and CAP_NET_RAW-less /bin/ping.  In
> order not to increase the kernel's attack surface, the new functionality
> is disabled by default, but is enabled at bootup by supporting Linux
> distributions, optionally with restriction to a group or a group range
> (see below).

You'll need to do a manpage patch too. Otherwise noone will know how to use
it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
