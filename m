Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab0LTKdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:33:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0LTKdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:33:12 -0500
Date: Mon, 20 Dec 2010 05:33:07 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/5] Change page reference hanlding semantic of page cache
Message-ID: <20101220103307.GA22986@infradead.org>
References: <cover.1292604745.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1292604745.git.minchan.kim@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You'll need to merge all patches into one, otherwise you create really
nasty memory leaks when bisecting between them.

