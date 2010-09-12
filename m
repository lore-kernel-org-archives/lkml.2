Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0ILR3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 13:29:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46932 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab0ILR3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 13:29:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
Date: Sun, 12 Sep 2010 19:28:20 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, jarkao2@gmail.com,
        eric.dumazet@gmail.com, herbert@gondor.hengli.com.au,
        kernel-testers@vger.kernel.org, maciej.rutecki@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stable@kernel.org
References: <1283672983.3402.38.camel@edumazet-laptop> <201009082221.16356.rjw@sisk.pl> <4C8C7957.7080207@fs.uni-ruse.bg>
In-Reply-To: <4C8C7957.7080207@fs.uni-ruse.bg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009121928.20238.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 12, 2010, Plamen Petrov wrote:
> На 08.9.2010 г. 23:21, Rafael J. Wysocki написа:
> > On Wednesday, September 08, 2010, David Miller wrote:
> >> From: Jarek Poplawski<jarkao2@gmail.com>
> >> Date: Wed, 8 Sep 2010 06:20:04 +0000
> >>
> >>> We need both of them. I hope David could add this too:
> >>>
> >>> Tested-by: Plamen Petrov<pvp-lsts@fs.uni-ruse.bg>
> >>
> >> Done, and applied, thanks :-)
> >
> > Please kindly let me know when Linus gets them, so that I can close the bug.
> >
> > Rafael
> 
> Now that both commits that fix my problems are in Linus' tree, the
> bug can be closed, but these fixes should go in 2.6.35.y, too.
> So, CCing -stable.

Thanks, bug closed.

Rafael
