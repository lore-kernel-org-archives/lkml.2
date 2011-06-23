Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab1FWKfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 06:35:25 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52204
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758860Ab1FWKfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 06:35:21 -0400
Date: Thu, 23 Jun 2011 06:35:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dehrenberg@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/6] DIO: Inline the complete submission path
Message-ID: <20110623103518.GA2439@infradead.org>
References: <1308770322-22565-1-git-send-email-andi@firstfloor.org>
 <1308770322-22565-7-git-send-email-andi@firstfloor.org>
 <20110622195955.GB24311@infradead.org>
 <20110622201026.GJ3263@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622201026.GJ3263@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 10:10:26PM +0200, Andi Kleen wrote:
> The compiler does that anyways.
> 
> Or did you mean in source? That would conflict with the coding standard.

Of course I meant the source.  I'm not sure what coding standard you
mean, but the current split is completely non-sensical.

