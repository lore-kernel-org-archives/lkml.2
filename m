Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2AaTTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:19:31 -0500
Received: from relay1.sgi.com ([192.48.179.29]:50407 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab2AaTTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:19:30 -0500
Date: Tue, 31 Jan 2012 13:19:28 -0600
From: Ben Myers <bpm@sgi.com>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>,
        Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH] xfs: show uuid when mount fails due to duplicate uuid
Message-ID: <20120131191928.GH7762@sgi.com>
References: <20120113055839.12919.98763.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113055839.12919.98763.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 02:58:39PM +0900, Mitsuo Hayasaka wrote:
> When a system tries to mount a filesystem (FS) using UUID, the xfs
> returns -EINVAL and shows a message if a FS with the same UUID has
> been already mounted. It is useful to output the duplicate UUID
> with it.
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>
