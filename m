Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab0KEGau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 02:30:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33278 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab0KEGas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 02:30:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RydptJRXOr7dfqFGeCsgpPU4LeEP8sl0hJcsXDwpp5q97Clt31Fl0fBPUMtzYQFXtu
         P+vDyYdOEcqJv2IriYEYx6l9DZM6wIUQOE3ZRS87Csf0KzCNBQDELS0Jk+btCTjLWnDg
         h/jOaXgH6ECczEPaeiS3Tn1HK1gkoO2Yy0FXA=
Subject: Re: [PATCH 46/49] net/netfilter: Use vzalloc
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>, Jesper Juhl <jj@chaosbits.net>
Cc: Jiri Kosina <trivial@kernel.org>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <7d6da34b7e84955795717b0241000a0701cd5b34.1288925425.git.joe@perches.com>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
	 <7d6da34b7e84955795717b0241000a0701cd5b34.1288925425.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 07:30:40 +0100
Message-ID: <1288938640.3234.12.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 04 novembre 2010 à 20:08 -0700, Joe Perches a écrit :
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  net/netfilter/x_tables.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)

So many 'vzalloc' patches for net tree... 

I had _one_ patch, waiting that David actually had vzalloc() in its tree
before sending it.

Given Jesper Juhl was doing this work, could you please take another
one, please ?

For example, explaining him how to use other tools than "bash+egrep
+manual inspection" as he mentioned in a previous mail.

Really Joe, your behavior should be smarter than that.

Thanks


