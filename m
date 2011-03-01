Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab1CAMKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 07:10:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35089 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab1CAMKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 07:10:15 -0500
Date: Tue, 1 Mar 2011 07:10:12 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] fs/9p: call vmtruncate before setattr 9p opeation
Message-ID: <20110301121012.GA15516@infradead.org>
References: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1298969484-16199-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298969484-16199-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 02:21:20PM +0530, Aneesh Kumar K.V wrote:
> We need to call vmtruncate before 9p setattr operation, otherwise we
> could write back some dirty pages between setattr with ATTR_SIZE and vmtruncate
> causing some truncated pages to be written back to server

Please read the documentation.  vmtruncate is deprecated and no new
users may be added at this point.

