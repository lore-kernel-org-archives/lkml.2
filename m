Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab2L1Mka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 07:40:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41255 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab2L1Mk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 07:40:27 -0500
Date: Fri, 28 Dec 2012 13:40:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
Message-ID: <20121228124026.GB12918@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sasha Levin <levinsasha928@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Josh Boyer <jwboyer@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Florian Tobias Schandinat <florianSchandinat@gmx.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20121116192606.11799.35711.stgit@localhost.localdomain>
 <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com>
 <20121121125310.00625f55@pyramind.ukuu.org.uk>
 <CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com>
 <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com>
 <CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com>
 <CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com>
 <20121227045301.GB17472@x1.alien8.de>
 <20121228115022.GA28009@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121228115022.GA28009@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 07:50:27PM +0800, Shawn Guo wrote:
> +1
> 
> http://thread.gmane.org/gmane.linux.kernel/1413953/focus=1415070

Cool, works fine here too. Is Linus on CC? (/me checks.. ) Yes he is,
good.

Linus, Alan's patch works at least in 2 cases, you might consider
picking it up directly since the fb maintainer is absent, reportedly.

Tested-by: Borislav Petkov <bp@alien8.de>

Thanks.

-- 
Regards/Gruss,
Boris.
