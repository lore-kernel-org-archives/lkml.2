Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab1IUPRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:17:39 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45530
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042Ab1IUPRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:17:38 -0400
Date: Wed, 21 Sep 2011 11:17:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        lidongyang@novell.com, joe.jin@oracle.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.2 - blkback and blkfront
 patches for 3.2
Message-ID: <20110921151732.GA28043@infradead.org>
References: <20110921150955.GH541@phenom.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921150955.GH541@phenom.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 11:09:55AM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please pull the following git tree in your 3.2 drivers tree:
> 
>  git pull git://oss.oracle.com/git/kwilk/xen.git stable/for-jens-3.2
> 
> which has an exciting new feature - the discard ('feature-discard')
> aka TRIM/UNMAP. Now they can be passed from the guest to the backend.

What is the design of them?  Do you provide the 'discard zeroes data'
flag (mandatory for any kind of relible operation) and 'discard
granularity / alignment' tunables (very useful)?

