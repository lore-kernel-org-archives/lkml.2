Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0LAIDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:03:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58396 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0LAIDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:03:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HVbgF+48/UVAUgjkgy5lOGhdSECcon3dHVWJXfIsP3ZtrlQszG4tyUkAGX/Vb7PBRB
         43neRrPwApofO4k+Pitc6bfKLikyH5IUdnY9eqgzqDXFYaHVtFeZ8oduz01Bj67GR2bA
         vfyT+Klb9l72NNCxJ53WGXt7VrjO3bYYTgwPE=
Subject: Re: [Patch] bonding: clean up netpoll code
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
        Neil Horman <nhorman@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <20101201075043.5741.29172.sendpatchset@localhost.localdomain>
References: <20101201075043.5741.29172.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 09:03:32 +0100
Message-ID: <1291190612.2856.481.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 décembre 2010 à 02:45 -0500, Amerigo Wang a écrit :
> Against net-next-2.6.
> 
> This patch unifies the netpoll code in bonding with netpoll code in bridge,
> thanks to Herbert that code is much cleaner now.
> 
> It also removes the flag IFF_IN_NETPOLL, we don't need it any more since
> we have netpoll_tx_running() now.
> 
> It passes my basic testings.

Sorry this NETPOLL patch is frightening...

Could you split it in several parts ?

The removal of IFF_IN_NETPOLL deserves a patch on its own, its not a
cleanup at all, if you ask me.

Thanks



