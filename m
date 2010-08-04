Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab0HDIul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 04:50:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42476 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0HDIuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 04:50:40 -0400
Date: Wed, 4 Aug 2010 04:50:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
 vg/lv - xfs
Message-ID: <20100804085039.GA11671@infradead.org>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804073546.GA7494@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 09:35:46AM +0200, Dominik Brodowski wrote:
> How can I best track down the cause of the performance problem, 
> a) without rebooting too often, and
> b) without breaking up the setup specified above (production system)?

So did you just upgrade the system from an earlier kernel that did not
show these problems?  Or did no one notice them before?

