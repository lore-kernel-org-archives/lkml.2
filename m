Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab1FKKck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 06:32:40 -0400
Received: from mars.netasq.com ([91.212.116.3]:50764 "EHLO work.netasq.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753958Ab1FKKcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 06:32:39 -0400
Date: Sat, 11 Jun 2011 12:30:31 +0200 (CEST)
From: Clement LECIGNE <clement.lecigne@netasq.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <474215859.237587.1307788231269.JavaMail.root@work1>
In-Reply-To: <20110610214036.GA23163@infradead.org>
Subject: Re: [BUG] hfs_find_init() sb->ext_tree NULL pointer dereference
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [88.169.180.107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

----- Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jun 08, 2011 at 01:07:55PM +0200, Clement LECIGNE wrote:
> -snip-
> Well, it can't happen in practice.  The extent file always fits into
> the first blocks for a valid extents file.  And yes, you could

If this can't happen then it should be reasonable to ban this case.

> artifically construct a filesystem where this is not true, and if you
> want to be cool call it a security issue.  But in the end anyone who
> mounts untrusted disk images has much worse issues than this, so don't
> do it.

Yes I agree but think about the case we are a simple user on the machine
without root. For example few years ago at my university I was able to
gain root priv thanks to a vulnerability in XFS quite similar to this one
(exploit which does the evil mmap(), plug usb key, automounting, sbam).

Best,

-- 
Clément LECIGNE,
