Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab1JZLZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 07:25:24 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43074
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932673Ab1JZLZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 07:25:23 -0400
Date: Wed, 26 Oct 2011 07:25:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Simon Kirby <sim@hostway.ca>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS read hangs in 3.1-rc10
Message-ID: <20111026112521.GA10432@infradead.org>
References: <20111020224214.GC22772@hostway.ca>
 <20111021132240.GA24136@infradead.org>
 <20111021202857.GB30100@hostway.ca>
 <20111024082219.GA19941@infradead.org>
 <20111025200748.GA25043@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025200748.GA25043@hostway.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 01:07:48PM -0700, Simon Kirby wrote:
> This patch seems to work, at least on an SSD box. No more hung task
> warnings, and everything appears normal.
> 
> Do we know what caused this regression and/or how to fix it without the
> big hammer, or do we need to break it down further?

I have an idea and will send you a refined patch soon.  I'm at a
conference until tomorrow, so you'll probably have to wait another day
or two for it.
