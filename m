Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0DKSzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 14:55:54 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:62509 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0DKSzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 14:55:53 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXJ75k/AprGTViQ=
X-RZG-CLASS-ID: mo00
Message-ID: <4BC21AC4.8060403@hartkopp.net>
Date: Sun, 11 Apr 2010 20:53:56 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: nm127@freemail.hu, eric.dumazet@gmail.com, oliver.hartkopp@volkswagen.de,
       urs.thuermann@volkswagen.de, socketcan-core@lists.berlios.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.34-rc3 + CAN build problem
References: <1270892851.2093.32.camel@edumazet-laptop>	<4BC054AE.7040303@freemail.hu>	<4BC070E0.6070601@hartkopp.net> <20100410.155009.66184583.davem@davemloft.net>
In-Reply-To: <20100410.155009.66184583.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
> 
> That's the only way you get an actual failure of a build when
> the user copy size can't be proven to be in range by the
> compiler, otherwise it just warns.

No, indeed i do not have it set.

# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

What would be the best approach to fix this build failure then?

By applying the patch thankfully provided by Eric?

Regards,
Oliver

