Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab0JWLrC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:47:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49343 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab0JWLrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:47:01 -0400
Date: Sat, 23 Oct 2010 07:46:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Arnd Bergmann <arnd@arndb.de>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] udf: Replace BKL with superblock's mutex s_lock
Message-ID: <20101023114655.GB23814@infradead.org>
References: <1287833853-4175-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287833853-4175-1-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No new uses of s_lock/lock_super/unlock_super, please.

