Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1FCFMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:12:34 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51958
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703Ab1FCFMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:12:33 -0400
Date: Fri, 3 Jun 2011 01:12:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hfsplus: add missing call to bio_put()
Message-ID: <20110603051232.GB16721@infradead.org>
References: <1306877750-6613-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306877750-6613-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 04:35:50PM -0500, Seth Forshee wrote:
> hfsplus leaks bio objects by failing to call bio_put() on the bios
> it allocates. Add the missing call to fix the leak.

Thanks, I'll send it on to Linus.

