Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0JNLRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 07:17:54 -0400
Received: from canuck.infradead.org ([134.117.69.58]:46374 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab0JNLRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 07:17:53 -0400
Date: Thu, 14 Oct 2010 07:17:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>, lmcilroy@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] vfs: fix overflow in direct-io subsystem
Message-ID: <20101014111752.GA6310@infradead.org>
References: <201010132245.57467.edward.shishkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010132245.57467.edward.shishkin@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 10:45:57PM +0200, Edward Shishkin wrote:
> Fix up overflow (ssize_t->int) in the direct-io subsystem.
> 
> Signed-off-by: Edward Shishkin <edward@redhat.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

