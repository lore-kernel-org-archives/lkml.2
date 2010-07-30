Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab0G3XfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 19:35:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872Ab0G3XfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 19:35:07 -0400
Date: Fri, 30 Jul 2010 16:34:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        Hanumath Prasad <hanumath.prasad@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] mmc: only set blockaddressed for > 2GiB cards
Message-Id: <20100730163457.a54cb0f1.akpm@linux-foundation.org>
In-Reply-To: <AANLkTin-EGaq9q0ATgRfm=XKTgJ7EYT_Q-Ruzr_OQXsY@mail.gmail.com>
References: <1277194762-21399-1-git-send-email-rabin.vincent@stericsson.com>
	<AANLkTin-EGaq9q0ATgRfm=XKTgJ7EYT_Q-Ruzr_OQXsY@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010 19:28:44 +0200
Linus Walleij <linus.walleij@stericsson.com> wrote:

> 2010/6/22 Rabin Vincent <rabin.vincent@stericsson.com>:
> 
> > From: Hanumath Prasad <hanumath.prasad@stericsson.com>
> >
> > A non-zero value of SEC_COUNT does not indicate that the card is sector
> > addressed. __According to the MMC specification, cards with a density
> > greater than 2GiB are sector addressed.
> 
> What's happening with this beauty? Andrew would you mind
> picking this one up please?

I merged that a month ago, for 2.6.36.

If we think that it should be in 2.6.35 (and earlier?) then please send
along revised changelog text which explains the reason for that.

