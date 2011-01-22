Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab1AVJbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 04:31:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35842 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1AVJbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 04:31:36 -0500
Date: Sat, 22 Jan 2011 04:31:34 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 06/10] block: kill request allocation batching
Message-ID: <20110122093133.GA6749@infradead.org>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-7-git-send-email-jaxboe@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295659049-2688-7-git-send-email-jaxboe@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 01:17:25AM +0000, Jens Axboe wrote:
> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

A little more explanation of this surely wouldn't hurt.

