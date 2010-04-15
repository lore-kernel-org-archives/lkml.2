Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab0DOADG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 20:03:06 -0400
Received: from khc.piap.pl ([195.187.100.11]:43811 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab0DOADE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 20:03:04 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Michael Barkowski <michaelbarkowski@ruggedcom.com>
Cc: "David S. Miller" <davem@davemloft.net>, Julia Lawall <julia@diku.dk>,
       "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: hdlc_ppp: why no detach()?
References: <4BC32B00.1030600@ruggedcom.com>
	<m3633todl2.fsf@intrepid.localdomain>
Date: Thu, 15 Apr 2010 02:02:59 +0200
In-Reply-To: <m3633todl2.fsf@intrepid.localdomain> (Krzysztof Halasa's message
	of "Thu, 15 Apr 2010 00:48:25 +0200")
Message-ID: <m3tyrdmvkc.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. The SCR packet will be delayed by 2 seconds (both first and second
>    SCR will be sent the same time). Perhaps we delay only a little
>    (instead of full 2 seconds) and only then send the initial packet.

BTW can I sleep in a netdevice_notifier callback, no?
-- 
Krzysztof Halasa
