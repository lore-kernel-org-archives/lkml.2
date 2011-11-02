Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1KBHgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 03:36:37 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49297
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301Ab1KBHgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 03:36:36 -0400
Date: Wed, 2 Nov 2011 03:36:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tao Ma <tm@tao.ma>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 for 3.2] fs/direct-io.c: Calculate fs_count correctly
 in get_more_blocks.
Message-ID: <20111102073632.GA17580@infradead.org>
References: <x49wrblav46.fsf@segfault.boston.devel.redhat.com>
 <1320200794-2881-1-git-send-email-tm@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320200794-2881-1-git-send-email-tm@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch looks good to me, but given that it neither fixes a bug
nor a regression I'd probably call it 3.3 material at this point.

