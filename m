Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab1ERSPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:15:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38086 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709Ab1ERSPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:15:22 -0400
Date: Wed, 18 May 2011 14:15:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tim Gardner <timg@tpi.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] 2.6.39-rc7+ fs: Fix spinlock recursion in
 get_active_super()
Message-ID: <20110518181520.GA17242@infradead.org>
References: <20110518163500.5CA99F912D@sepang.rtg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518163500.5CA99F912D@sepang.rtg.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How can you reproduce that recursion?  Given that grab_super drops
sb_lock I can't see any way to hit it.

