Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab2HSHJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 03:09:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38121 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab2HSHJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 03:09:55 -0400
Date: Sun, 19 Aug 2012 10:09:46 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: dedekind1@gmail.com
Cc: Richard Genoud <richard.genoud@gmail.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] UBI: replace MTD_UBI_BEB_LIMIT with user-space
 parameter
Message-ID: <20120819100946.646cbb8a@pixies.home.jungo.com>
In-Reply-To: <1345124012.3393.239.camel@sauron.fi.intel.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	<1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
	<20120816115713.726da8f2@pixies.home.jungo.com>
	<CACQ1gAhFJ6AKYJpc1ZiHm+3Y=APnwUmVL3f0KW=OFMDMWzCVJg@mail.gmail.com>
	<20120816134234.32b468f6@pixies.home.jungo.com>
	<1345124012.3393.239.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012 16:33:32 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
> We do not have that big user-base. No one uses 0 in the tree, most use
> the default. I never heard anyone using 0. I did not use it also. I
> think it is OK to have the lower range start from non-zero. But why it
> is 2 and not 1 - I am not sure :-)

Artem,

Note that originally range was 0..25 (percentage).

It was changed to be 2..256 (per 1024) by 07ad322 in linux-ubi.

Seems arbitrary change.
So if you'd like, we can fix to 1..256 (or 0..256) - as you prefer.

Regards,
Shmulik
