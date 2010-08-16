Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab0HPXR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 19:17:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32908 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab0HPXRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 19:17:55 -0400
Date: Mon, 16 Aug 2010 19:17:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        matthew@wil.cx
Subject: Re: [PATCH] fs.h: introduce functions to get/set file->private_data
Message-ID: <20100816231753.GA16546@infradead.org>
References: <201008161137.53187.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008161137.53187.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 11:37:52AM -0700, H Hartley Sweeten wrote:
> The symbol 'private_data' is commonly used and makes grep'ing for
> specific uses difficult. Introduce the wrapper functions file_get_privdata
> and file_set_privdata to help with the struct file uses.

This just obsfucates the code, NAK.

