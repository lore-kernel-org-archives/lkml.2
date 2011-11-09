Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1KIHsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 02:48:53 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58537
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346Ab1KIHsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 02:48:52 -0500
Date: Wed, 9 Nov 2011 02:48:47 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <chris.mason@oracle.com>, Arne Jansen <sensille@gmx.net>,
        Andrea Gelmini <andrea.gelmini@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs pull request
Message-ID: <20111109074847.GA16742@infradead.org>
References: <20111106183851.GA4339@shiny>
 <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
 <4EB7A6CC.5030502@gmx.net>
 <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com>
 <4EB7D2D8.2060505@gmx.net>
 <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com>
 <4EB8DEAC.7000906@gmx.net>
 <20111109010701.GI4149@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109010701.GI4149@shiny>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 08:07:01PM -0500, Chris Mason wrote:
> Looks like bio_add_page() is failing and we're getting the enomem from
> there.  LVM is only letting us put one page in each bio.

Yes, at the moment all bio based DM targets only allow single page I/O.

