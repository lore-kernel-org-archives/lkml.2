Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab0FWW16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:27:58 -0400
Received: from mail.perches.com ([173.55.12.10]:1260 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab0FWW1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:27:55 -0400
Subject: Re: [PATCH] MAINTAINERS: Add an entry for the input MT protocol
From: Joe Perches <joe@perches.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1277330664-13884-1-git-send-email-rydberg@euromail.se>
References: <1277330664-13884-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jun 2010 15:27:52 -0700
Message-ID: <1277332072.31591.92.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 00:04 +0200, Henrik Rydberg wrote:
> This patch adds a maintainer for the input multitouch (MT) protocol,
> such that get_maintainer.pl selects it whenever an MT event is present
> in the patch.

> +MULTITOUCH INPUT MT PROTOCOL
> +M:	Henrik Rydberg <rydberg@euromail.se>
> +L:	linux-input@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/input/multi-touch-protocol.txt
> +K:	ABS_MT

That doesn't seem to match anything other than multitouch
stuff, but it's probably best to specify the pattern as
much as possible.

If you didn't know, K: entries can be entered as perl regex,
so maybe something like:

K:	\b(ABS|SYN)_MT_


