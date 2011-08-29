Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1H2Vva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:51:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58433 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab1H2Vv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:51:28 -0400
Subject: Re: [PATCH 18/24] sctp: Remove unnecessary OOM logging messages
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1314654209.2563.7.camel@edumazet-laptop>
References: <cover.1314650069.git.joe@perches.com>
	 <21b4d996c8861373ac77d427914ec7882fe0c83e.1314650069.git.joe@perches.com>
	 <1314654209.2563.7.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 23:51:21 +0200
Message-ID: <1314654681.2563.10.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 août 2011 à 23:43 +0200, Eric Dumazet a écrit :

> Furthermore, a failed vmalloc() is not guaranteed to emit an OOM
> message, is it ?

It currently displays a message without context :

vmap allocation for size XXXXXX failed: use vmalloc=<size> to increase
size.

So we dont know which part of the kernel asked this allocation.

Please dont remove existing error messages after failed vmalloc() calls.



