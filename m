Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab1IFFpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 01:45:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48517 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752031Ab1IFFpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 01:45:42 -0400
Date: Mon, 5 Sep 2011 22:45:38 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH] backlight: Fix broken regulator API usage in l4f00242t03
Message-ID: <20110906054537.GB20379@opensource.wolfsonmicro.com>
References: <1315246208-26006-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4E659A56.9060305@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E659A56.9060305@gmx.de>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 03:58:14AM +0000, Florian Tobias Schandinat wrote:
> Hm, it looks like Richard did not respond on this email address for months. But
> I noticed there exists a Richard@linuxfoundation and according to
> http://lwn.net/Articles/419640/rss
> I'd guess it is the same person. If this is true, would you, Richard, *please*
> update your email address in MAINTAINERS so people do not needlessly wait for
> feedback for ages.
> For the patch itself, it looks good to me, but I really feel not qualified to
> handle the backlight things. So I'll let handle Andrew any backlight patches for
> now but could carry patches in my tree if they get Richard's Ack/Signed-off.

They're both the same Richard and as far as I know both addresses work
just as well, it's not an e-mail issue but more that Richard has been
focusing on things other than kernel work recently and Andrew has been
picking things up instead (as can be seen in the git history).
