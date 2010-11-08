Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0KHPJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:09:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47204 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0KHPJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:09:02 -0500
Date: Mon, 8 Nov 2010 10:08:57 -0500
From: Christoph Hellwig <hch@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@infradead.org, nab@linux-iscsi.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, hch@lst.de,
        hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk,
        bharrosh@panasas.com
Subject: Re: [RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
Message-ID: <20101108150857.GA14585@infradead.org>
References: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
 <20101108143307.GA22121@infradead.org>
 <20101108234328C.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108234328C.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, while I'm at it - target_core_transport.c could defintively use
some split up into smaller files while we're at it.

