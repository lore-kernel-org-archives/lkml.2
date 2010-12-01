Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0LAR2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:28:20 -0500
Received: from mail.perches.com ([173.55.12.10]:2053 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab0LAR2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:28:19 -0500
Subject: Re: [ath9k-devel] [PATCH wireless-next] ath: Rename ath_print to
 ath_debug
From: Joe Perches <joe@perches.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k-devel@venema.h4ckr.net, peter@stuge.se,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291223825.1845.170.camel@Joe-Laptop>
References: <5febb0e1fba0ec2bb77f6ade8b251ba0edf4614c.1290988277.git.joe@perches.com>
	 <AANLkTinc251WbwuLqFbOZ5ipNGZW7=wub3DoWwy42=+e@mail.gmail.com>
	 <20101129060732.5130.qmail@stuge.se> <4CF42C17.2070500@openwrt.org>
	 <1291081185.16349.133.camel@Joe-Laptop> <4CF464D6.2020507@openwrt.org>
	 <1291148375.18026.342.camel@Joe-Laptop>
	 <AANLkTik2qtGUgkZYSjcEH9jHHsevKnxOvz4s6On94U9o@mail.gmail.com>
	 <1291213675.1845.12.camel@Joe-Laptop>  <4CF65DB9.3050007@openwrt.org>
	 <1291223825.1845.170.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 09:28:17 -0800
Message-ID: <1291224497.1845.172.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define ath_emerg(common, fmt, ...)				\
> +	ath_printk(KERN_EMERG, common, fmt, ##__VA_ARGS)

Sorry, that patch is defective. (and an old version)

That's what I get for not using git format-patch to send it.
I'll resend it appropriately.

