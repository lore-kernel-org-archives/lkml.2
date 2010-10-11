Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab0JKJjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:39:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45751 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab0JKJjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:39:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BJQZ4XfuzFHGtlOF9iM10VSv2NxwLdVcIdVk/+YoF57ViSRio2HaqauJO4JmD5y9/l
         lwJnzs/lgjPGhU5gR6zHoYoQcZ7i+v6XSsMKOsJV/ORve8qgr5msGhfhrK0O5IAh7i3c
         u5RRwpIb4sf9i9ue//fmJDxd5FovI8kA+Xnu4=
Subject: Re: [PATCH 1/3] NET: pch, fix use after free
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Masayuki Ohtake <masa-korg@dsn.okisemi.com>
In-Reply-To: <1286789218-13976-1-git-send-email-jslaby@suse.cz>
References: <1286789218-13976-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 11:38:38 +0200
Message-ID: <1286789918.2737.8.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 11 octobre 2010 à 11:26 +0200, Jiri Slaby a écrit :
> Stanse found that pch_gbe_xmit_frame uses skb after it is freed. Fix
> that.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> ---
>  drivers/net/pch_gbe/pch_gbe_main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applicable to net-next-2.6 only, this driver is not yet in Linus tree

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



