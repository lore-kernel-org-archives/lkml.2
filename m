Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab0KGO10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 09:27:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39740 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab0KGO1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 09:27:25 -0500
Date: Sun, 7 Nov 2010 09:27:19 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        Alessio Igor Bogani <abogani@texware.it>,
        Arnd Bergmann <arnd@arndb.de>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] udf: Add missed protection for s_lvid_dirty
Message-ID: <20101107142719.GA25234@infradead.org>
References: <1289065631-2256-1-git-send-email-abogani@texware.it>
 <20101106180530.GB13315@infradead.org>
 <20101107141403.GF5126@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107141403.GF5126@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 03:14:03PM +0100, Jan Kara wrote:
>   Looking at it now, cleaner fix might be to move the counters to sbi and
> write them to the LVID only during umount. So that might be a nice cleanup
> as well.

Yes, that's what we're doing in most filesystems for these counters.

