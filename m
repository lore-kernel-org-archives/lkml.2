Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2GQCfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:35:40 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:33412 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab2GQCfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:35:38 -0400
Message-ID: <5004CF3A.6080704@parallels.com>
Date: Tue, 17 Jul 2012 06:34:34 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Vagin <avagin@openvz.org>, "David S. Miller" <davem@davemloft.net>
CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-next: make sock diag per-namespace (v2)
References: <1342448929-1809316-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1342448929-1809316-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 06:28 PM, Andrew Vagin wrote:
> Before this patch sock_diag works for init_net only and dumps
> information about sockets from all namespaces.
> 
> This patch expands sock_diag for all name-spaces.
> It creates a netlink kernel socket for each netns and filters
> data during dumping.
> 
> v2: filter accoding with netns in all places
>     remove an unused variable.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: James Morris <jmorris@namei.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Andrew Vagin <avagin@openvz.org>

Acked-by: Pavel Emelyanov <xemul@parallels.com>
