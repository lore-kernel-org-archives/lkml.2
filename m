Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab2AXSCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:02:50 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49338
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197Ab2AXSCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:02:48 -0500
Date: Tue, 24 Jan 2012 13:02:42 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>, Alex Elder <elder@kernel.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH] xfs: show uuid when mount fails due to duplicate uuid
Message-ID: <20120124180242.GD23671@infradead.org>
References: <20120113055839.12919.98763.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113055839.12919.98763.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 02:58:39PM +0900, Mitsuo Hayasaka wrote:
> When a system tries to mount a filesystem (FS) using UUID, the xfs
> returns -EINVAL and shows a message if a FS with the same UUID has
> been already mounted. It is useful to output the duplicate UUID
> with it.

The new version looks fine to me, thanks a lot!
