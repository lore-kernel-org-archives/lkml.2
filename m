Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab0JHHxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:53:22 -0400
Received: from canuck.infradead.org ([134.117.69.58]:52101 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab0JHHxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:53:21 -0400
Date: Fri, 8 Oct 2010 03:53:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
Message-ID: <20101008075320.GA30902@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-16-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static unsigned int last_ino_get(void)

Shouldn't this be get_next_ino?

Otherwise looks okay for now.


Reviewed-by: Christoph Hellwig <hch@lst.de>
