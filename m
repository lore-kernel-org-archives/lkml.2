Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab0HATp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 15:45:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0HATpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 15:45:25 -0400
Date: Sun, 1 Aug 2010 15:45:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] NFS: Fix build failure on !CONFIG_NFS_V3 &&
 !CONFIG_NFS_V3
Message-ID: <20100801194502.GA3801@infradead.org>
References: <1280519035.12852.32.camel@heimdal.trondhjem.org>
 <20100801064415.GA10523@elte.hu>
 <AANLkTim=6q1FC8YZvmi2Cju_6+00mHHkNPpCLHB8e3=h@mail.gmail.com>
 <1280684100.4430.8.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280684100.4430.8.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, is there a reason to allow not building NFSv3?  If at all
building without v2 support would be more useful.

