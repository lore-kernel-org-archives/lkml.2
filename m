Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2FTHwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:52:24 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44177
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755013Ab2FTHwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:52:23 -0400
Date: Wed, 20 Jun 2012 03:52:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Engelhardt <jengelh@inai.de>
Cc: xfs@oss.sgi.com, hch@infradead.org, joe@perches.com, bpm@sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] types.h: implement intptr_t and uintptr_t
Message-ID: <20120620075216.GA24798@infradead.org>
References: <1338487534-14575-1-git-send-email-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338487534-14575-1-git-send-email-jengelh@inai.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd really like to get Jans type cleanups in XFS in for the next
merge window.  Given the lack of feedback on lkml in favor or
against (u)intptr_t I'm tempted to add them to xfs_linux.h for now,
and then do another push to propagate them to kernel-wide types later.

Is that fine with everybody?

