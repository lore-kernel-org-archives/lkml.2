Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0KXDEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 22:04:24 -0500
Received: from mail4.comsite.net ([205.238.176.238]:34293 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0KXDEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 22:04:23 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=75.92.62.227;
From: Milton Miller <miltonm@bga.com>
Subject: Re: trivial: make comment about vs{n,cn,}printf more understandable
To: <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Will Schmidt <will_schmidt@vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <1290528765-25057-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1290528765-25057-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Tue, 23 Nov 2010 21:04:04 -0600
X-Originating-IP: 75.92.62.227
Message-ID: <1290567844_20137@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 at about 16:12:45 -0000, Uwe Kleine-König wrote:
> 
> "You probably want ... instead." sounds like a recommendation better
> not to use the v... functions.
> 

Which is true, if you dont' have a va_list its hard to get them.
But I do get your point.

>   * the @buf not including the trailing '\0'. If @size is <= 0 the function
>   * returns 0.
>   *
> - * Call this function if you are already dealing with a va_list.
> - * You probably want scnprintf() instead.
> + * If you're not already dealing with a va_list better use scnprintf().

That doesn't flow off my (mid-western usa) tounge.

How about
 * Call this function if you are already dealing with a va_list.
 * Otherwise you probably want to use scnprintf().

Alternatively,
 * If you're not already dealing with a va_list consider scnprintf().

Thanks,
milton
