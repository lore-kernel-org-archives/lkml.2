Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab1KIKLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:11:20 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59139
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754149Ab1KIKLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:11:18 -0500
Date: Wed, 9 Nov 2011 05:11:14 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Arne Jansen <sensille@gmx.net>
Cc: Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>,
        Andrea Gelmini <andrea.gelmini@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs pull request
Message-ID: <20111109101114.GA20506@infradead.org>
References: <20111106183851.GA4339@shiny>
 <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
 <4EB7A6CC.5030502@gmx.net>
 <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com>
 <4EB7D2D8.2060505@gmx.net>
 <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com>
 <4EB8DEAC.7000906@gmx.net>
 <20111109010701.GI4149@shiny>
 <20111109074847.GA16742@infradead.org>
 <4EBA42AF.3000501@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBA42AF.3000501@gmx.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 10:06:55AM +0100, Arne Jansen wrote:
> That's... unexpected. I guess this won't change with 3.3? For 3.3 I have
> to rework that part from scrub to account for Chris' bigblocks. If it can
> wait that long I'd prefer to fix both at once. Chris?

device mapper has always been like that.  It makes splitting requests
over multiple targets a lot easier for them.  With increasin I/O sizes
that is something which will have to be fixed sooner or later, though.

