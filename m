Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2DDJHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 05:07:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43886 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2DDJHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 05:07:48 -0400
Subject: Re: Commit 8ef874bfc7296fa206eea2ad1e8a426f576bf6f6 has broken ss
 command
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: netdev@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120404090312.1B68C6AC03E@msa102.auone-net.jp>
References: <20120404090312.1B68C6AC03E@msa102.auone-net.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Apr 2012 11:07:43 +0200
Message-ID: <1333530463.18626.545.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 18:03 +0900, Kusanagi Kouichi wrote:
> Since commit 8ef874bfc7296fa206eea2ad1e8a426f576bf6f6 ("sock_diag:
> Move the sock_ code to net/core/"), ss command from iproute package
> doesn't work if INET_DIAG is not enabled.
> 
> $ ss
> State       Recv-Q Send-Q                                             Local Address:Port                                                 Peer Address:Port
> TCPDIAG answers: Operation not supported
> --

Try to update your iproute2 package ?


