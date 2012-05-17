Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab2EQQWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:22:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60183 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab2EQQWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:22:21 -0400
Date: Thu, 17 May 2012 18:21:34 +0200 (CEST)
From: Eldad Zack <eldadzack@gmail.com>
X-X-Sender: eldad@debianer
To: Stephen Hemminger <shemminger@vyatta.com>
cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Jamal Hadi Salim <hadi@cyberus.ca>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: correct the ipv6 option name - Pad0 to Pad1
In-Reply-To: <20120517090923.0d0930e9@nehalam.linuxnetplumber.net>
Message-ID: <alpine.DEB.2.02.1205171816310.22002@debianer>
References: <1337270425-21873-1-git-send-email-eldad@fogrefinery.com> <20120517090923.0d0930e9@nehalam.linuxnetplumber.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 17 May 2012, Stephen Hemminger wrote:
> On Thu, 17 May 2012 18:00:25 +0200
> Eldad Zack <eldad@fogrefinery.com> wrote:
> 
> > The padding destination or hop-by-hop option is called Pad1 and not Pad0.
> > 
> > See RFC2460 (4.2) or the IANA ipv6-parameters registry:
> > http://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xml
> > 
> > Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
> 
> If standards bodies want to call a 0 a 1, then I guess we have to follow :-)

Yeah, Pad0 is a much better name for it. That's probably why it never
occured to any one for so long :-)
