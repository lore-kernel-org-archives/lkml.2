Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab2LTPip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:38:45 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:32820 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2LTPij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:38:39 -0500
Subject: Re: [PATCH] net: ipv4: route: fix coding style issues net: ipv4:
 tcp: fix coding style issues
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefan Hasko <hasko.stevo@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1356013685-31649-1-git-send-email-hasko.stevo@gmail.com>
References: <1356013685-31649-1-git-send-email-hasko.stevo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Dec 2012 07:31:07 -0800
Message-ID: <1356017467.21834.2838.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-20 at 15:28 +0100, Stefan Hasko wrote:
> Fix a coding style issues.
> 
> Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
> ---
>  net/ipv4/route.c |  119 ++++++++++++++++-------------
>  net/ipv4/tcp.c   |  218 +++++++++++++++++++++++++++++++-----------------------
>  2 files changed, 194 insertions(+), 143 deletions(-)


I Nack this patch and any such patches in net/core, net/ipv4 trees for a
while.

We had too many recent changes and probably need a bunch of real fixes.

Thanks


