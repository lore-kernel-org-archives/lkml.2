Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3AEVXv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 16:23:51 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46407 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab3AEVXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 16:23:49 -0500
Date: Sat, 5 Jan 2013 13:20:17 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] AB8500 battery management series upgrade
Message-ID: <20130105212014.GA1246@lizard.mcd00620.sjc.wayport.net>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 03:21:23PM +0000, Lee Jones wrote:
> Please find the next instalment of the AB8500 Power drivers upgrade.
> A lot of work has taken place on the internal development track, but
> little effort has gone into mainlining it. At last count there were
> around 70+ patches which are in need of forward-porting, then
> upstreaming. This patch-set aims to make a good start. :)

Lee,

The series seem like a part of a larger 57-patches series that I reviewed
in late September (it took me 3 days to review it back then :).

So, today I took a look at the first few patches, and I see that none of
my comments were addressed. I guess there is some internal
miscommunication between the teams, so maybe you didn't know about the
previous effort of upstreaming the fixes.

So, please take a look at these comments:

	http://lkml.org/lkml/2012/9/25/587

Thanks!
Anton
