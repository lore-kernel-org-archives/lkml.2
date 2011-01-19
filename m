Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1ASQld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:41:33 -0500
Received: from mail.perches.com ([173.55.12.10]:3196 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab1ASQlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:41:32 -0500
Subject: Re: [PATCH v2] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Joe Perches <joe@perches.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ratbert@faraday-tech.com, bhutchings@solarflare.com,
        eric.dumazet@gmail.com, dilinger@queued.net
In-Reply-To: <AANLkTi=nJxwR89CF3i0+L6+yM4Bg_PN8PQByTAHP2nPM@mail.gmail.com>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com>
	 <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
	 <1295284788.21277.65.camel@Joe-Laptop>
	 <AANLkTi=nJxwR89CF3i0+L6+yM4Bg_PN8PQByTAHP2nPM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 08:41:30 -0800
Message-ID: <1295455290.1952.22.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 17:40 +0800, Po-Yu Chuang wrote:
> On Tue, Jan 18, 2011 at 1:19 AM, Joe Perches <joe@perches.com> wrote:
> > on split long line indentation style
> > and long function declarations.
[]
> > Most of drivers/net uses an alignment to open parenthesis
> > using maximal tabs and minimal necessary spaces instead of
> > an extra tabstop.
[]
> Well, TBH, I don't like this style because if I changed the
> function name, the indentation might need to be adjusted.

No worries.  That could happen using either style.

There's no required style so you can use what you are
most comfortable doing.  It's not a big deal at all.

> Even worse, I got an infeasible case :-(
> 
> static struct ftmac100_rxdes *ftmac100_rx_locate_first_segment(
> 							       struct ftmac100 *priv)
> 
> I know my function names are quite long, but I like them to be descriptive.
> Do you really insist on it?

Here's a common alternative style for this case:

static struct ftmac100_rxdes *
ftmac100_rx_locate_first_segment(struct ftmac100 *priv)


