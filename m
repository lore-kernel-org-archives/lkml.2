Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2AXRqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:46:36 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49275
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757167Ab2AXRqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:46:35 -0500
Date: Tue, 24 Jan 2012 12:46:12 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>, xfs-masters@oss.sgi.com,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 0/3] xfs: change available ranges in quota check
Message-ID: <20120124174612.GC9853@infradead.org>
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 12:45:14PM +0900, Mitsuo Hayasaka wrote:
> Hi,
> 
> This patch series changes available ranges of softlimit and
> hardlimit in quota check, as follows.
> 
> (1) Consider new reservation for quota check
>     The disk block reservation checks if (current usage + new
>     reservation) reach the quota limit although the inode reservation
>     does not use the new reservation for quota check. It should
>     consider it, as well. This is mandatory for (2).

Can you send a testcase that reproduces issues with the old behaviour?

