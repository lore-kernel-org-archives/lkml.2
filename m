Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab0K2O6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 09:58:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39454 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0K2O6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 09:58:21 -0500
Date: Mon, 29 Nov 2010 09:58:18 -0500
From: Christoph Hellwig <hch@infradead.org>
To: npiggin@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/7] fs: simple fsync race fix
Message-ID: <20101129145818.GB26076@infradead.org>
References: <20101123140610.292941494@kernel.dk>
 <20101123140707.773579845@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123140707.773579845@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of removing the data sync support here and re-adding it later
I would recommend moving the enhanced sync_inode_metadata earlier in
the series.

