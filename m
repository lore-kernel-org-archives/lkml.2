Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0LAO16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:27:58 -0500
Received: from mail.perches.com ([173.55.12.10]:2043 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab0LAO14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:27:56 -0500
Subject: Re: [ath9k-devel] [PATCH wireless-next] ath: Rename ath_print to
 ath_debug
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k-devel@venema.h4ckr.net, peter@stuge.se,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTik2qtGUgkZYSjcEH9jHHsevKnxOvz4s6On94U9o@mail.gmail.com>
References: <5febb0e1fba0ec2bb77f6ade8b251ba0edf4614c.1290988277.git.joe@perches.com>
	 <AANLkTinc251WbwuLqFbOZ5ipNGZW7=wub3DoWwy42=+e@mail.gmail.com>
	 <20101129060732.5130.qmail@stuge.se> <4CF42C17.2070500@openwrt.org>
	 <1291081185.16349.133.camel@Joe-Laptop> <4CF464D6.2020507@openwrt.org>
	 <1291148375.18026.342.camel@Joe-Laptop>
	 <AANLkTik2qtGUgkZYSjcEH9jHHsevKnxOvz4s6On94U9o@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 06:27:55 -0800
Message-ID: <1291213675.1845.12.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 23:56 -0800, Luis R. Rodriguez wrote:
> On Tue, Nov 30, 2010 at 12:19 PM, Joe Perches <joe@perches.com> wrote:
> > Poor function naming is just that.
> > It reduces readability and the uses are counter expectation.
> The name is perfect, we use it to print anything, even non-debugging stuff.

'fraid not.

ath/debug.h

#ifdef CONFIG_ATH_DEBUG
void ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
	__attribute__ ((format (printf, 3, 4)));
#else
static inline void __attribute__ ((format (printf, 3, 4)))
ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
{
}
#endif /* CONFIG_ATH_DEBUG */


