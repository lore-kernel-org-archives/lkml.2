Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0FFTFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 15:05:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab0FFTFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 15:05:51 -0400
Date: Sun, 6 Jun 2010 15:05:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Brian Swetland <swetland@google.com>, Arve Hj?nnev?g <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
Message-ID: <20100606190525.GA20517@infradead.org>
References: <1275834706.7227.545.camel@mulgrave.site>
 <alpine.LFD.2.00.1006061725000.2933@localhost.localdomain>
 <1275844114.7227.552.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275844114.7227.552.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 06, 2010 at 12:08:34PM -0500, James Bottomley wrote:
> Well, we sort of tried this when Greg pulled some of them into the
> staging tree.  The problem is that without the annotations, the drivers
> are still different, and patches won't apply, so, unsurprisingly, they
> didn't get improved or even maintained.

Err, the biggest pile in staging was meta drivers like the binder or
some oom killer magic which are flat out braindead and wrong and have
no chance going into mainline anyway.  That's something different from
real hardware drivers, although a few of those made it into staging as
well if I remember correctly.

