Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1JJLJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:09:09 -0400
Received: from verein.lst.de ([213.95.11.211]:39072 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab1JJLJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:09:08 -0400
Date: Mon, 10 Oct 2011 13:09:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
        viro@zeniv.linux.org.uk, dchinner@redhat.com, hch@lst.de
Subject: Re: [PATCH v2] ramfs: Remove module leftovers
Message-ID: <20111010110907.GB28672@lst.de>
References: <1318244079-10815-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318244079-10815-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 12:54:39PM +0200, Richard Weinberger wrote:
> Since ramfs is hard-selected to "y", the module leftovers make
> no sense.

Removing the dead code looks good, but what is the point in using
device_initcall?  We've always been using module_init for non-modular
code, though.

