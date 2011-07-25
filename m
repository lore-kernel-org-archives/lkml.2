Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab1GYNpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:45:12 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42263
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab1GYNpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:45:10 -0400
Date: Mon, 25 Jul 2011 09:44:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd: change the field "b_cow_tid" of struct journal_head
 from type unsigned to tid_t
Message-ID: <20110725134442.GA9826@infradead.org>
References: <4E2D6961.9000909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2D6961.9000909@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 09:02:25PM +0800, Wang Sheng-Hui wrote:
> The patch is against 3.0
> 
> In the definition of struct journal_head, the comment for
> the field "unsigned b_cow_tid" says the field tracks the
> last transaction id in which this buffer has been cowed.

The correct fix is to simply remove the field, as it's entirely unused.

