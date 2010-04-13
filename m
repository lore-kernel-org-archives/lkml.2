Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab0DMLIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 07:08:23 -0400
Received: from stinky.trash.net ([213.144.137.162]:47197 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0DMLIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:08:22 -0400
Message-ID: <4BC450A4.1010200@trash.net>
Date: Tue, 13 Apr 2010 13:08:20 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, bhutchings@solarflare.com, andreas@fatal.se,
       hadi@cyberus.ca, hideaki@yoshifuji.org
Subject: Re: [PATCH v2] xtables: make XT_ALIGN() usable in exported headers
 by exporting __ALIGN_KERNEL()
References: <20100407162245.GA4557@x200> <4BC437C6.8020602@trash.net> <4BC44117.80901@trash.net> <20100414120712.GA25686@x200>
In-Reply-To: <20100414120712.GA25686@x200>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> XT_ALIGN() was rewritten through ALIGN() by commit 42107f5009da223daa800d6da6904d77297ae829
> "netfilter: xtables: symmetric COMPAT_XT_ALIGN definition".
> ALIGN() is not exported in userspace headers, which created compile problem for tc(8)
> and will create problem for iptables(8).
> 
> We can't export generic looking name ALIGN() but we can export less generic
> __ALIGN_KERNEL() (suggested by Ben Hutchings).
> Google knows nothing about __ALIGN_KERNEL().
> 
> COMPAT_XT_ALIGN() changed for symmetry.

I've already pushed your change out, could you send me an incremental
fix please?

master.kernel.org:/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git
