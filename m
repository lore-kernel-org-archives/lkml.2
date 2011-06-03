Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab1FCTzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:55:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60717 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1FCTzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sryMb64bEidEHvT7qyFGjML9BqvJsnz0ICwWJqennIeiUnOLYCmVxNfkhvoHbWDPXR
         3jbx1frZCkhZqYaUfjwCwVsVd5Ykav31IdXThef02VccRhPklWcY9M3tiM3zQblRh41t
         O6HVQPhpO9rLaJwDk1Z0T5AItl6UQBTSO/7mY=
Subject: Re: bridge/netfilter: regression in 2.6.39.1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org
In-Reply-To: <4DE93B31.8040700@ahsoftware.de>
References: <4DE93422.3070000@ahsoftware.de>
	 <1307129642.2600.2.camel@edumazet-laptop>  <4DE93B31.8040700@ahsoftware.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 21:55:14 +0200
Message-ID: <1307130914.2600.12.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 03 juin 2011 à 21:51 +0200, Alexander Holler a écrit :
> Hello,
> 
> Am 03.06.2011 21:34, schrieb Eric Dumazet:
> >>
> >> Commit 42923465fb8d025a2b5153f2e7ab1e6e1058bf00 does here what it
> >> should prevent, it introduces NULL a dereference.
> >>
> >
> > I cant find this commit in known trees. Could you give the real commit
> > id and its title ?
> 
> Sorry, I haven't seen that question at first. This is the real commit id 
> as found in the stable tree for 2.6.39. The title of that commit is
> "bridge: initialize fake_rtable metrics"

OK, its commit id is 33eb9873a283a2076f2b5628813d5365ca420ea9

Please always use linux-2.6 tree commits, this saves a lot of time.

Thanks


