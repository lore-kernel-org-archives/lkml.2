Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0LRJWH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 04:22:07 -0500
Received: from verein.lst.de ([213.95.11.210]:50212 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab0LRJWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 04:22:03 -0500
Date: Sat, 18 Dec 2010 10:20:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        Shane Michael Matthews <shane.matthews@intel.com>
Subject: Re: [PATCH] Add readpages support for block devices
Message-ID: <20101218092049.GA32442@lst.de>
References: <1292632073-6196-1-git-send-email-willy@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292632073-6196-1-git-send-email-willy@linux.intel.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already used to have this and Jens reverted it in commit
172124e220f1854acc99ee394671781b8b5e2120.  I can't find a better
explanation than his rather brief commit message, but he might not more.

