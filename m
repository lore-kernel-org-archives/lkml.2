Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0IHUW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:22:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34840 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab0IHUWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:22:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
Date: Wed, 8 Sep 2010 22:21:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: jarkao2@gmail.com, pvp-lsts@fs.uni-ruse.bg, eric.dumazet@gmail.com,
        herbert@gondor.hengli.com.au, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1283672983.3402.38.camel@edumazet-laptop> <20100908062004.GA6280@ff.dom.local> <20100908.103256.112592448.davem@davemloft.net>
In-Reply-To: <20100908.103256.112592448.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009082221.16356.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 08, 2010, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Wed, 8 Sep 2010 06:20:04 +0000
> 
> > We need both of them. I hope David could add this too:
> > 
> > Tested-by: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
> 
> Done, and applied, thanks :-)

Please kindly let me know when Linus gets them, so that I can close the bug.

Rafael
