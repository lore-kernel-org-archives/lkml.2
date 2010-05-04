Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0EDKcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 06:32:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51981 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab0EDKcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 06:32:33 -0400
Date: Tue, 4 May 2010 06:32:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Fredrick Prashanth John Berchmans <fredrickprashanth@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: nfs accesses of FAT fs folders causes deadlock on lock_super
Message-ID: <20100504103232.GA25054@infradead.org>
References: <x2gd4f60c3c1005032259p8be864bcucff91618016a0eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x2gd4f60c3c1005032259p8be864bcucff91618016a0eb@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 10:59:42PM -0700, Fredrick Prashanth John Berchmans wrote:
> The box was running kernel version 2.6.27.10.
> But I think the FAT code has not changed much.

But the nfsd code has and now doesn't call lookup from the filldir
callback anymore.

