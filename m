Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab0J1MAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:00:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab0J1MAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:00:19 -0400
Date: Thu, 28 Oct 2010 08:00:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fs: peel back the inode_lock some more
Message-ID: <20101028120016.GA4546@infradead.org>
References: <1288266161-28897-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288266161-28897-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't inode_lock be completely gone after these?

also I hope moving to global locks really is just a step inbetween.
Especially for writeback I doubt moving from inode_lock to another
global lock makes a whole lot of difference - nevermind that it's
not too smart to lock per-object lists with a global lock.

