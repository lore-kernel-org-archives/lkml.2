Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0J3PDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 11:03:33 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:49650 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0J3PDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 11:03:31 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 30 Oct 2010 08:03:15 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@localhost6.localdomain6
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Alban Crequy <alban.crequy@collabora.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pauli Nieminen <pauli.nieminen@collabora.co.uk>,
        Rainer Weikusat <rweikusat@mssgmbh.com>
Subject: Re: [PATCH] af_unix: unix_write_space() use keyed wakeups
In-Reply-To: <1288421084.2680.717.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1010300759580.9195@localhost6.localdomain6>
References: <20101029191857.5f789d56@chocolatine.cbg.collabora.co.uk>  <1288380431.2680.3.camel@edumazet-laptop> <1288421084.2680.717.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Oct 2010, Eric Dumazet wrote:

> This patch is a specialization of commit 37e5540b3c9d (epoll keyed
> wakeups: make sockets use keyed wakeups).

Whoops, I must have missed AF_UNIX :)
Looks good to me.


- Davide


