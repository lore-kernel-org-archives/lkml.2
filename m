Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab2GQHXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:23:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43536 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2GQHXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:23:45 -0400
Date: Tue, 17 Jul 2012 10:23:33 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Subject: Re: [PATCH 0/5] ubi: Fix bad PEBs reserve caclulation
Message-ID: <20120717102333.26cb10fb@pixies.home.jungo.com>
In-Reply-To: <1342452837.7270.15.camel@brekeke>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
	<1342452837.7270.15.camel@brekeke>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Mon, 16 Jul 2012 18:33:57 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
> But one more think is the mtd web-site. I've grepped for '1%' and there
> are plenty of them. I've changed them all to 2% more or less
> mechanically - only cleaned up one section by removing out-of-date
> information. Would you please grep for '2%' and review if the
> information there is reasonable? Also, would you please add some more
> info to this FAQ entry:
> 
> http://linux-mtd.infradead.org/faq/ubi.html#L_bad_blocks_exceeded
> 
> Or even better if you could write a separate section for this stuff in
> the documentation, then you could remove that FAQ entry completely.

Sure, I'll try to do it as well.

But it would only make sense after accepting Richard's patchset as well,
which suggests configuring per-ubi-device beb limit via the attach ioctl.

I didn't had the time to properly review it yet, but IMO it looks more
controversial.
http://lists.infradead.org/pipermail/linux-mtd/2012-July/042803.html

Regards,
Shmulik
