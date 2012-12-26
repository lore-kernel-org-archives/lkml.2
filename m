Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab2LZWJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 17:09:11 -0500
Received: from mail.us.es ([193.147.175.20]:60243 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab2LZWJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 17:09:06 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.6/16120. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-98.0/7.5):. 
 Processed in 1.855231 secs); 26 Dec 2012 22:09:04 -0000
X-Envelope-From: pneira@us.es
Date: Wed, 26 Dec 2012 23:09:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: netfilter@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, Jay Schulist <jschlst@samba.org>,
        Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] netfilter: Don't leak 'exp' in
 ctnetlink_create_expect()
Message-ID: <20121226220902.GA30981@1984>
References: <alpine.LNX.2.00.1212262246390.23814@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1212262246390.23814@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 10:49:40PM +0100, Jesper Juhl wrote:
> 'if ((!help) && (!cda[CTA_EXPECT_TIMEOUT]))' then we should remember
> to free 'exp' that was allocated by 'nf_ct_expect_alloc()' by jumping
> to the 'err_out' label rather than the 'out' label in
> ctnetlink_create_expect().
> This patch should get rid of the leak.

Applied, thanks Jesper.
