Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab2BION2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:13:28 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:51109 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab2BION1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:13:27 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 46/50] wan: use dev_hw_addr_random() instead of random_ether_addr()
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de>
	<1328735457-29986-47-git-send-email-danny.kukawka@bisect.de>
Date: Thu, 09 Feb 2012 15:12:05 +0100
In-Reply-To: <1328735457-29986-47-git-send-email-danny.kukawka@bisect.de>
	(Danny Kukawka's message of "Wed, 8 Feb 2012 22:10:53 +0100")
Message-ID: <m3vcng2j0q.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Danny Kukawka <danny.kukawka@bisect.de> writes:

> Use dev_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/net/wan/hdlc_fr.c      |    2 +-
>  drivers/net/wan/hdlc_raw_eth.c |    2 +-

Acked-by: Krzysztof Halasa <khc@pm.waw.pl>
-- 
Krzysztof Halasa
