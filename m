Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab2DPIVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:21:08 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:52685 "HELO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751035Ab2DPIVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:21:05 -0400
Message-ID: <4F8BD633.5080207@mellanox.com>
Date: Mon, 16 Apr 2012 11:20:03 +0300
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>
CC: Jesper Juhl <jj@chaosbits.net>, <linux-kernel@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] IB: mlx4: Fix mem leaks in ib_link_query_port()
References: <alpine.LNX.2.00.1204112340360.2137@swampdragon.chaosbits.net> <4F8A7A15.4060908@mellanox.com> <CAL1RGDXeny6ouGBD67OKYEa+m9cZ_x=NOaEGjPT6S62_BzWvuw@mail.gmail.com>
In-Reply-To: <CAL1RGDXeny6ouGBD67OKYEa+m9cZ_x=NOaEGjPT6S62_BzWvuw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/2012 8:05 AM, Roland Dreier wrote:
> thanks, applied (looks like a 3.4 regression so I'll send the fix to Linus with my next batch)

not sure to follow on the next branch part, it is a regression 
introduced in 3.4-rc1 so it should be in your fixes branch
and submitted within a batch possibly containing more fixes, isn't that?


Or.
