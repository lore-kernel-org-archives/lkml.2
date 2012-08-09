Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab2HIHpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 03:45:43 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45052
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293Ab2HIHpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 03:45:42 -0400
Date: Thu, 9 Aug 2012 03:45:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org,
        martin.petersen@oracle.com, vgoyal@redhat.com, neilb@suse.de
Subject: Re: [RFC]block: disable discard request merge temporarily
Message-ID: <20120809074537.GA14639@infradead.org>
References: <20120809052803.GA11814@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809052803.GA11814@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 01:28:03PM +0800, Shaohua Li wrote:
> The SCSI discard request merge never worked, and looks no solution for in
> future, let's disable it temporarily.
> 
> Signed-off-by: Shaohua Li <shli@fusionio.com>

Looks good and is equivalent to what I proposed over a year aggo,

Reviewed-by: Christoph Hellwig <hch@lst.de>
