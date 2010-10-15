Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab0JOXjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 19:39:41 -0400
Received: from verein.lst.de ([213.95.11.210]:56583 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab0JOXjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 19:39:40 -0400
Date: Sat, 16 Oct 2010 01:39:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com
Subject: Re: [PATCH] fs: move exportfs since it is not a networking filesystem
Message-ID: <20101015233922.GA1035@lst.de>
References: <20101015163227.3edf2f42.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015163227.3edf2f42.randy.dunlap@oracle.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, thanks!


Reviewed-by: Christoph Hellwig <hch@lst.de>

