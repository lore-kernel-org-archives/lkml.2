Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab0IXSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:16:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250Ab0IXSQY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <20100924100733.2e7fa2ac@jbarnes-desktop>
References: <20100917223109.24687.17697.stgit@bob.kio> <20100917223212.24687.3519.stgit@bob.kio>
 <20100924100733.2e7fa2ac@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Sep 2010 11:15:54 -0700
Message-ID: <AANLkTikiEsqReicJxurQXf7GghKQjJ3agooefs59eULC@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] resources: ensure alignment callback doesn't
 allocate below available start
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 10:07 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Applied this series.  It's way bigger than I'd like at this point, but
> it does fix some regressions, so I'll give Linus the option of pulling
> it in my next pull request.  If he declines, we'll put it into -next
> and tag it for inclusion into the stable series.

I definitely am not going to pull this series for 2.6.36.

I could possibly take this first one that only prepares for the real
change and doesn't actually change anything in itself, but switching
around the order of allocations after -rc5 would be crazy. Yes, it may
help some people, but we have absolutely no idea who it could hurt. So
the whole thing is definitely something for the merge window (and
preferably pretty early there too)

                       Linus
