Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab2DDKAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 06:00:18 -0400
Received: from msa106.auone-net.jp ([61.117.18.166]:43282 "EHLO
	msa106.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab2DDKAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 06:00:17 -0400
Date: Wed, 4 Apr 2012 19:00:15 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Commit 8ef874bfc7296fa206eea2ad1e8a426f576bf6f6 has broken ss
 command
References: <20120404090312.1B68C6AC03E@msa102.auone-net.jp>
 <1333530463.18626.545.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333530463.18626.545.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <20120404100015.D41B162C03E@msa106.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-04 11:07:43 +0200, Eric Dumazet wrote:
> On Wed, 2012-04-04 at 18:03 +0900, Kusanagi Kouichi wrote:
> > Since commit 8ef874bfc7296fa206eea2ad1e8a426f576bf6f6 ("sock_diag:
> > Move the sock_ code to net/core/"), ss command from iproute package
> > doesn't work if INET_DIAG is not enabled.
> > 
> > $ ss
> > State       Recv-Q Send-Q                                             Local Address:Port                                                 Peer Address:Port
> > TCPDIAG answers: Operation not supported
> > --
> 
> Try to update your iproute2 package ?

iproute seems up to date.
$ ss --version
ss utility, iproute2-ss120319

I tried git master commit 4bb00cd2b7525ad7d6cf6bbea945ad6e546873f4.
It still fails.
