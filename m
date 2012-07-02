Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2GBTy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 15:54:57 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51430 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124Ab2GBTyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 15:54:55 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.43.174]
In-Reply-To: <4FF1F145.2050408@codeaurora.org>
References: <1338017791-9442-1-git-send-email-ohad@wizery.com>
 <4FC5DBFA.2030300@codeaurora.org> <CAK=WgbZJJJPuNWVv8WgL=KKm6Hrx2krDD9gBOTP7sA8p7mh_rA@mail.gmail.com>
 <CAK=WgbbREXV8nkF4vh9iLUp1WQj2ZLYW6VG8Urmw9=roy63meQ@mail.gmail.com> <4FF1F145.2050408@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 2 Jul 2012 22:54:34 +0300
Message-ID: <CAK=WgbZ+=MGU5juuOP+_vtUe4d_46j=Rd0cqYi7q2i-9T35R5w@mail.gmail.com>
Subject: Re: [PATCH 1/2] remoteproc: maintain a generic child device for each rproc
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 10:06 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Great! It looks like device_type doesn't have any list iteration support
> though. Is that requirement gone?

Pretty much, yeah. I'll soon post a separate patch which removes the
get_by_name functionality (together with its related klist).

> Will you resend this as part of a series? It will be easier to review then.

Not sure. There's a collection of discrete patches that I've been
posting, but they really aren't an organic series: as long as the
dependencies are met, each and every one of them is applicable even if
applied alone.

So I'd prefer (when possible) to treat patches in a discrete fashion
so we can start applying them and unblock others who depend on them
(e.g. Fernando's runtime PM work depends on this one).

But if you prefer me to send this one patch differently to make it
easier to review, let me know!

Thanks,
Ohad.
