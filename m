Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1DTShO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:37:14 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:54791 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485Ab1DTShM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:37:12 -0400
MIME-Version: 1.0
In-Reply-To: <143ea9b1bb96e613d534caa7cb3a1e2d.squirrel@www.codeaurora.org>
References: <1302822031-6752-1-git-send-email-sjg@chromium.org>
	<4DA7A914.5020804@codeaurora.org>
	<BANLkTikcY-xzjd0W77UfWWoO8ibjKNXQGg@mail.gmail.com>
	<BANLkTin_TpzdQS96SPKUNye6vb2b55Qc4A@mail.gmail.com>
	<143ea9b1bb96e613d534caa7cb3a1e2d.squirrel@www.codeaurora.org>
Date: Wed, 20 Apr 2011 13:37:04 -0500
Message-ID: <BANLkTi=Zxt96b50DiuE_KVf2dv_vJooFnA@mail.gmail.com>
Subject: Re: [PATCH v4] ARM: Use generic BUG() handler
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
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
        Dave Martin <dave.martin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Apr 20, 2011 at 1:01 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> It's here:
> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6885/1
>
> I imagine it will be added when/if Russell picks it up. Sadly it
> increases the LOC in ARM so Simon might need to really
> sell it to get it merged.

I guess saying that it indirectly fixes wrong code generation on some
cases[1] might give an extra push.

Regards,

Omar

---
[1] http://lkml.org/lkml/2011/3/31/490
