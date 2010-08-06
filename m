Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935233Ab0HFCPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:15:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760380Ab0HFCPx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:15:53 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinU4+tcm2O_BVBFkHSdnx7JEPtM4sw_s--qdUKC@mail.gmail.com>
References: <20100803.203814.59697285.davem@davemloft.net> 
	<AANLkTimxv1y3QJ7s+ghi1FFCcwnUVWT1n6dvT-NNN=Oo@mail.gmail.com> 
	<AANLkTinU4+tcm2O_BVBFkHSdnx7JEPtM4sw_s--qdUKC@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Aug 2010 19:15:04 -0700
Message-ID: <AANLkTi=3dVWKtgL2A=4xm_1VSk64--3Zk_fQBYUdAAn+@mail.gmail.com>
Subject: Re: [GIT] Networking
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 7:04 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>
>  CC      drivers/net/ixgbe/ixgbe_main.o
> drivers/net/ixgbe/ixgbe_main.c: In function ‘ixgbe_select_queue’:
> drivers/net/ixgbe/ixgbe_main.c:6159: error: ‘struct ixgbe_fcoe’ has no member named ‘up’

Hmm. You must have some other version of that file than I do. Line
6159 is in ixgbe_init_module() in my source tree.

                 Linus
