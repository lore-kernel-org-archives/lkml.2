Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948Ab0FRLGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 07:06:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:3461 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468Ab0FRLGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 07:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TSYH2Q84KAJg7SsDbE3MqD2hy7NXDeYH6Ste2ce/gQjTB1k3ugYdp3Pxp+/uqzQd5r
         TIfTqVaAU0PTwVGuCytQlIzxwU7oFqs3B+eBE3cbagQk5/w2pm9mQAMw6/Vw9DBXt3d6
         hzR0cxWNB/wkN7bdrR1ZCdP+BUx+wJ0gImwoA=
Subject: Re: [PATCH] ath5k: disable ASPM
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       Bob Copeland <bcopeland@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100618134930.124225d4fsi8w1fk@naisho.dyndns.info>
References: <20100528100901.14580.1322.stgit@fate.lan>
	 <1276806785.20754.8.camel@maxim-laptop>
	 <20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
	 <1276856142.9114.1.camel@maxim-laptop>
	 <20100618134930.124225d4fsi8w1fk@naisho.dyndns.info>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 14:05:56 +0300
Message-ID: <1276859156.19554.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 13:49 +0300, Jussi Kivilinna wrote: 
> Quoting "Maxim Levitsky" <maximlevitsky@gmail.com>:
> 
> >> (ok, I might switch back ath5k to work on this, but opening AAO is
> >> pain.. on the other hand, I'm just user in this case and pretty
> >> unwilling to work with dual-license)
> > What do you mean?
> 
> Patch I made uses GPL code from e1000e, but since ath5k is  
> dual-licensed so patch can't be accepted. So if I got it right, patch  
> has to be remade from scratch by someone who really knows about pci  
> registers etc. I don't, and learning this to fix something that is  
> already fixed in my point of view is waste of (my) time.
Sure, regardless of licensing, this patch has to be redone (and e1000
with it)

Best regards,
Maxim Levitsky

