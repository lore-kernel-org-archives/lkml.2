Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935744Ab1ETMUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 08:20:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935420Ab1ETMUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 08:20:11 -0400
Date: Fri, 20 May 2011 08:20:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alex Bligh <alex@alex.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: REQ_FLUSH, REQ_FUA and open/close of block devices
Message-ID: <20110520122010.GA25628@infradead.org>
References: <10C5890F8F477E959B993BFA@nimrod.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10C5890F8F477E959B993BFA@nimrod.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 04:06:27PM +0100, Alex Bligh wrote:
> Should a close() of a dirty block device result in a REQ_FLUSH?

No, why would it?  That's what fsync is for.

