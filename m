Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab0JKITk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 04:19:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56252 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0JKITi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 04:19:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pyF6UHQJ+MdhBh8lXwqsZjTt493GN/YyTA6Q5kT2BMz90fx/uVlWMBQrFDzvVzluqe
         ybMaisr26gRtCb1yrLFS4qP+pRYUEOLW8/fIcXbuJdS7aZ9iv0lerAGASvPd/ZLZ1U8b
         bdQ2OT0kKhUxP8Ll6Ax/9Gd4Zb62fkc/Y3m2U=
Subject: Re: [PATCH 1/1] ATM: solos-pci, remove use after free
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Chas Williams <chas@cmf.nrl.navy.mil>
In-Reply-To: <1286783444-7719-1-git-send-email-jslaby@suse.cz>
References: <1286783444-7719-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 10:19:29 +0200
Message-ID: <1286785169.2737.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 11 octobre 2010 à 09:50 +0200, Jiri Slaby a écrit :
> Stanse found we do in console_show:
>   kfree_skb(skb);
>   return skb->len;
> which is not good. Fix that by remembering the len and use it in the
> function instead.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Chas Williams <chas@cmf.nrl.navy.mil>
> ---

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



