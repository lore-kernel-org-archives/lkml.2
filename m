Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0IHRcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 13:32:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54144
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716Ab0IHRci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 13:32:38 -0400
Date: Wed, 08 Sep 2010 10:32:56 -0700 (PDT)
Message-Id: <20100908.103256.112592448.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: pvp-lsts@fs.uni-ruse.bg, eric.dumazet@gmail.com,
        herbert@gondor.hengli.com.au, rjw@sisk.pl,
        kernel-testers@vger.kernel.org, maciej.rutecki@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100908062004.GA6280@ff.dom.local>
References: <1283672983.3402.38.camel@edumazet-laptop>
	<4C8717BB.2050504@fs.uni-ruse.bg>
	<20100908062004.GA6280@ff.dom.local>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Wed, 8 Sep 2010 06:20:04 +0000

> We need both of them. I hope David could add this too:
> 
> Tested-by: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>

Done, and applied, thanks :-)
