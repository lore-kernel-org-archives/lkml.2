Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab0DKFOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 01:14:51 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:57942 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0DKFOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 01:14:49 -0400
Message-ID: <4BC15AC7.3010904@freemail.hu>
Date: Sun, 11 Apr 2010 07:14:47 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: socketcan@hartkopp.net, eric.dumazet@gmail.com,
       oliver.hartkopp@volkswagen.de, urs.thuermann@volkswagen.de,
       socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.34-rc3 + CAN build problem
References: <1270892851.2093.32.camel@edumazet-laptop>	<4BC054AE.7040303@freemail.hu>	<4BC070E0.6070601@hartkopp.net> <20100410.155009.66184583.davem@davemloft.net>
In-Reply-To: <20100410.155009.66184583.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Original: 94.21.187.224
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> Date: Sat, 10 Apr 2010 14:36:48 +0200
> 
>> So i wonder why Nemeth trapped into this problem ... probably an include file
>> mix-up?
> 
> Do you have CONFIG_DEBUG_STRICT_USER_COPY_CHECKS enabled in your
> kernel config?

CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y

> That's the only way you get an actual failure of a build when
> the user copy size can't be proven to be in range by the
> compiler, otherwise it just warns.
> 
> 

