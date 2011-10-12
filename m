Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1JLPDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:03:38 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33012
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056Ab1JLPDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:03:37 -0400
Date: Wed, 12 Oct 2011 11:03:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        akpm@linux-foundation.org, toshi.okajima@jp.fujitsu.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 0/13] read-only remount race fix v7
Message-ID: <20111012150332.GA25289@infradead.org>
References: <1318430946-7091-1-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318430946-7091-1-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 04:48:53PM +0200, Miklos Szeredi wrote:
> Here's an update of the read-only remount race fixes.
> 
> It should now fix the races after unlink.  I haven't been able to
> trigger the bad behavior with the test scripts provided by Toshiyuki
> Okajima.

How does the test script look like?  Could we integrate it into xfstests
so that we have a good regular run regression test for this?

