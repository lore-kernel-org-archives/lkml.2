Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3AGJha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 04:37:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab3AGJh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 04:37:29 -0500
Date: Mon, 7 Jan 2013 10:37:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Borislav Petkov <bp@alien8.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
In-Reply-To: <20121228124026.GB12918@x1.alien8.de>
Message-ID: <alpine.LRH.2.00.1301071037010.5443@twin.jikos.cz>
References: <20121116192606.11799.35711.stgit@localhost.localdomain> <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com> <20121121125310.00625f55@pyramind.ukuu.org.uk> <CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com>
 <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com> <CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com> <CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com> <20121227045301.GB17472@x1.alien8.de>
 <20121228115022.GA28009@S2101-09.ap.freescale.net> <20121228124026.GB12918@x1.alien8.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2012, Borislav Petkov wrote:

> > http://thread.gmane.org/gmane.linux.kernel/1413953/focus=1415070
> 
> Cool, works fine here too. Is Linus on CC? (/me checks.. ) Yes he is,
> good.
> 
> Linus, Alan's patch works at least in 2 cases, you might consider
> picking it up directly since the fb maintainer is absent, reportedly.
> 
> Tested-by: Borislav Petkov <bp@alien8.de>

Still seeing it with current Linus' tree.
  
        Tested-by: Jiri Kosina <jkosina@suse.cz>
  
Anyone applying this, please?

-- 
Jiri Kosina
SUSE Labs

