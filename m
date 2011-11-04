Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1KDMRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:17:46 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33825
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748Ab1KDMRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:17:45 -0400
Date: Fri, 4 Nov 2011 08:17:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        FS <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL REQUEST] writeback changes for 3.2-rc1
Message-ID: <20111104121742.GA19192@infradead.org>
References: <20111102030016.GA23054@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102030016.GA23054@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

any reason this hasn't been pulled yet?  The changes are fairly
important for any kind of buffered I/O workloads on medium and large
machines.

