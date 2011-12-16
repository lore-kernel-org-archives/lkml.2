Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630Ab1LPTeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:34:24 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37996
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264Ab1LPTeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:34:18 -0500
Date: Fri, 16 Dec 2011 14:34:14 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2]block: recursive merge requests
Message-ID: <20111216193414.GA30654@infradead.org>
References: <1324000363.22361.453.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324000363.22361.453.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 09:52:43AM +0800, Shaohua Li wrote:
> With recursive merge below, the workload throughput gets improved 20%
> and context switch drops 60%.

What workload and what filesystem?

