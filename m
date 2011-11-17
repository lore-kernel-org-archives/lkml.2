Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab1KQUIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:08:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45666 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1KQUIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:08:20 -0500
Message-ID: <1321560495.2444.1.camel@edumazet-laptop>
Subject: Re: [PATCH FIX net-next v1] net-forcedeth: fix possible stats
 inaccuracies on 32b hosts
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Decotigny <david.decotigny@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Rick Jones <rick.jones2@hp.com>
Date: Thu, 17 Nov 2011 21:08:15 +0100
In-Reply-To: <34add86253ddd91d5d4d4c7fee9c90f63a8d8edf.1321558587.git.david.decotigny@google.com>
References: <cover.1321558587.git.david.decotigny@google.com>
	 <34add86253ddd91d5d4d4c7fee9c90f63a8d8edf.1321558587.git.david.decotigny@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 17 novembre 2011 à 11:38 -0800, David Decotigny a écrit :
> The software stats are updated from BH, this change ensures that 32b
> UP hosts use appropriate protection.
> 
> Tested:
>   - HW/SW stats consistent with pktgen (in particular tx=rx)
>   - HW/SW stats consistent when tx/rx offloads disabled
>   - no problem with+without lockdep (SMP 16-way)
> 
> 
> 
> Signed-off-by: David Decotigny <david.decotigny@google.com>

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


