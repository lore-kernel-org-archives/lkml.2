Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab1ETNCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:02:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44250 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab1ETNCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:02:17 -0400
Date: Fri, 20 May 2011 09:02:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, James.Bottomley@suse.de,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH]: Fix Ultrastor asm snippet
Message-ID: <20110520130215.GB3428@infradead.org>
References: <20110518150605.GA25262@const.bordeaux.inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518150605.GA25262@const.bordeaux.inria.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 05:06:05PM +0200, Samuel Thibault wrote:
> Commit 1292500b replaced
> 
> "=m" (*field) : "1" (*field)
> 
> with
> 
> "=m" (*field) :
> 
> with comment "The following patch fixes it by using the '+' operator on
> the (*field) operand, marking it as read-write to gcc."
> '+' was actually forgotten.  This really puts it.

Do you actually have the hardware or was this just a code audit?

I have the strong suspicion that this driver is pretty much dead and
bitrotting.

