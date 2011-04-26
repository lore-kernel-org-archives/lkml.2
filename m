Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab1DZBsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 21:48:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61186 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783Ab1DZBsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 21:48:36 -0400
Date: Mon, 25 Apr 2011 18:47:41 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: anish singh <anish198519851985@gmail.com>, Simon Glass <sjg@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: [PATCH v4] ARM: Use generic BUG() handler
Message-ID: <20110426014741.GB28721@quad.lixom.net>
References: <1302822031-6752-1-git-send-email-sjg@chromium.org>
 <4DA7A914.5020804@codeaurora.org>
 <BANLkTikcY-xzjd0W77UfWWoO8ibjKNXQGg@mail.gmail.com>
 <BANLkTin_TpzdQS96SPKUNye6vb2b55Qc4A@mail.gmail.com>
 <143ea9b1bb96e613d534caa7cb3a1e2d.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <143ea9b1bb96e613d534caa7cb3a1e2d.squirrel@www.codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 11:01:59AM -0700, Stephen Boyd wrote:

> It's here:
> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6885/1
> 
> I imagine it will be added when/if Russell picks it up. Sadly it
> increases the LOC in ARM so Simon might need to really
> sell it to get it merged.

It's core code though, and the concern today is not with ARM core code
as much as with the various platforms that are growing seemingly without
upper bounds.


-Olof
