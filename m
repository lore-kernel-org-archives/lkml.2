Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab2LJPEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 10:04:54 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37117 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2LJPEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 10:04:52 -0500
Date: Mon, 10 Dec 2012 10:03:41 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Abhijit Pawar <abhi.c.pawar@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Cong Wang <amwang@redhat.com>, Eric Dumazet <edumazet@google.com>,
        Joe Perches <joe@perches.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH RESEND] net: remove obsolete simple_strto<foo>
Message-ID: <20121210150341.GD23628@hmsreliant.think-freely.org>
References: <1355130748-7828-1-git-send-email-abhi.c.pawar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355130748-7828-1-git-send-email-abhi.c.pawar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 02:42:28PM +0530, Abhijit Pawar wrote:
> This patch replace the obsolete simple_strto<foo> with kstrto<foo>
> 
> Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

