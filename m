Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0DMSHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:07:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab0DMSHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:07:30 -0400
Date: Tue, 13 Apr 2010 14:07:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, hch@infradead.org
Subject: Re: [PATCH 4/4] patch blk-add-zeroout-helper.patch
Message-ID: <20100413180730.GF21302@infradead.org>
References: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org> <1271077437-7921-2-git-send-email-dmonakhov@openvz.org> <1271077437-7921-3-git-send-email-dmonakhov@openvz.org> <1271077437-7921-4-git-send-email-dmonakhov@openvz.org> <1271077437-7921-5-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271077437-7921-5-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks okayish to me, but it really needs:

 a) a useful patch description
 b) patches that introduce actual users

Also why does the function have a __ prefix in the name?

