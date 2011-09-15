Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919Ab1IOOsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:48:16 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44795
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933801Ab1IOOsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:48:12 -0400
Date: Thu, 15 Sep 2011 10:48:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] hfsplus regression fixes
Message-ID: <20110915144810.GA18876@infradead.org>
References: <20110722152722.GA11946@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722152722.GA11946@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

two small patches to fix regressions introduced in the Linux 3.1 cycle.

Given that it's just two patches I have't bothered setting up an
alternate git tree for now.
