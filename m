Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2EOMtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:49:13 -0400
Received: from ra.se.axis.com ([195.60.68.13]:37168 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629Ab2EOMtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:49:12 -0400
Date: Tue, 15 May 2012 14:49:09 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 07/18] cris: Use common threadinfo allocator
Message-ID: <20120515124908.GG19174@axis.com>
References: <20120505150007.543515803@linutronix.de> <20120505150141.681236240@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120505150141.681236240@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 05:05:43PM +0200, Thomas Gleixner wrote:
> There is no functional difference. __get_free_pages() ends up calling
> alloc_pages_node().
> 
> This also allocates only one page which matches THREAD_SIZE instead of
> an extra page for nothing.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
