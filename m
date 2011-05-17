Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1EQIeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:34:07 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51727 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1EQIeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nM69aeoaI6TIIDF00danOGAjR+kmXVvAGcRC1MfUime8DsHkXyzuXWn/LRApzQZOEv
         x1tmeSK6eM/rFaBbTa0l67aXPVuUSuX6Y/JmcFnHjNhG9OL5wGTf3Xd95A9pmgt+rqrK
         aI7iNpkBky6BDPNgFW4kSqufflYwwWzI/Bkoo=
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexander Zimmermann <alexander.zimmermann@comsys.rwth-aachen.de>
Cc: Benoit Sigoure <tsunanet@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <E5F8880D-72DF-488B-9515-60453D3EC240@comsys.rwth-aachen.de>
References: <1305618020-72535-1-git-send-email-tsunanet@gmail.com>
	 <1305618020-72535-2-git-send-email-tsunanet@gmail.com>
	 <E5F8880D-72DF-488B-9515-60453D3EC240@comsys.rwth-aachen.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 10:34:01 +0200
Message-ID: <1305621241.2850.18.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 mai 2011 à 10:01 +0200, Alexander Zimmermann a écrit :

> 
> regardless of netdev will accept this patch or not, the
> upcoming initRTO is 1s. See
> http://tools.ietf.org/id/draft-paxson-tcpm-rfc2988bis-02.txt
> 
> The draft is IESG approved and will become an RFC soon.

Thanks Alex for this link / information.



