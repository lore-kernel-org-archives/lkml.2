Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab1ISQyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:54:43 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49145 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750841Ab1ISQym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:54:42 -0400
Subject: Re: [PATCH] Return -EIO when xfs_vn_getattr() failed
From: Alex Elder <aelder@sgi.com>
Reply-To: <aelder@sgi.com>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
CC: Christoph Hellwig <hch@infradead.org>, <xfs-masters@oss.sgi.com>,
        <xfs@oss.sgi.com>, <linux-kernel@vger.kernel.org>,
        <yrl.pp-manager.tt@hitachi.com>
In-Reply-To: <20110917133838.27791.63070.stgit@ltc219.sdl.hitachi.co.jp>
References: <20110917133838.27791.63070.stgit@ltc219.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 11:54:37 -0500
Message-ID: <1316451277.2941.30.camel@doink>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.232.50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-09-17 at 22:38 +0900, Mitsuo Hayasaka wrote:
> An attribute of inode can be fetched via xfs_vn_getattr() in XFS.
> Currently it returns EIO, not negative value, when it failed.
> As a result, the system call returns not negative value even though
> an error occured. The stat(2), ls and mv commands cannot handle this
> error and do not work correctly.
> 
> This patch fixes this bug, and returns -EIO, not EIO when an error
> is detected in xfs_vn_getattr().
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Alex Elder <aelder@sgi.com>
> Cc: Christoph Hellwig <hch@infradead.org>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


