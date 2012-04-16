Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987Ab2DPFGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 01:06:18 -0400
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:51628 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750789Ab2DPFGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 01:06:17 -0400
MIME-Version: 1.0
In-Reply-To: <4F8A7A15.4060908@mellanox.com>
References: <alpine.LNX.2.00.1204112340360.2137@swampdragon.chaosbits.net> <4F8A7A15.4060908@mellanox.com>
From: Roland Dreier <roland@kernel.org>
Date: Sun, 15 Apr 2012 22:05:55 -0700
X-Google-Sender-Auth: JnckRGXQcGPmPdtfhpDdBOt--ME
Message-ID: <CAL1RGDXeny6ouGBD67OKYEa+m9cZ_x=NOaEGjPT6S62_BzWvuw@mail.gmail.com>
Subject: Re: [PATCH] IB: mlx4: Fix mem leaks in ib_link_query_port()
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied (looks like a 3.4 regression so I'll send the fix to
Linus with my next batch)
