Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab0H0RQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:16:20 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:60014 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0H0RQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:16:19 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOuPd0yrRN+J/2dsb2JhbACgW3GgcJwAhTcEhDuFTg
X-IronPort-AV: E=Sophos;i="4.56,279,1280707200"; 
   d="scan'208";a="355905258"
From: Roland Dreier <rdreier@cisco.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Marc Aurele La France <tsi@ualberta.ca>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola \(ipv6\)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: MTU for serving NFS on Infiniband
References: <alpine.LNX.2.00.1008230842290.9325@abcyxhiz.aict.ualberta.ca>
	<20100823080543.319143e3@nehalam>
	<alpine.WNT.2.00.1008240856170.2000@cluij.ucs.ualberta.ca>
	<1282672647.2302.15.camel@achroite.uk.solarflarecom.com>
	<alpine.WNT.2.00.1008241338470.1132@cluij.ucs.ualberta.ca>
	<1282688441.22839.34.camel@localhost> <20100824153920.63360072@s6510>
	<alpine.WNT.2.00.1008251408520.632@cluij.ucs.ualberta.ca>
	<1282823827.2476.663.camel@edumazet-laptop>
	<alpine.WNT.2.00.1008260835020.2008@cluij.ucs.ualberta.ca>
	<20100826165359.3b79b27d@nehalam> <adaiq2w2fk0.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 27 Aug 2010 10:16:15 -0700
In-Reply-To: <adaiq2w2fk0.fsf@cisco.com> (Roland Dreier's message of "Fri, 27
	Aug 2010 09:20:15 -0700")
Message-ID: <adaeidk2cyo.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way, for the original poster: is using NFS/RDMA a possibility?
That might give even better performance than any config of IPoIB if you
have an InfiniBand fabric anyway.

 - R.
