Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1C3Drg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 23:47:36 -0400
Received: from relay3.sgi.com ([192.48.152.1]:39274 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753729Ab1C3Drf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 23:47:35 -0400
Subject: Re: [PATCH] delete a warning in function xfs_buf_readahead
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: Pan Weiping <panweiping3@gmail.com>
Cc: xfs-masters@oss.sgi.com, dchinner@redhat.com, hch@lst.de, tj@kernel.org,
        jaxboe@fusionio.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <1301455686-21517-1-git-send-email-panweiping3@gmail.com>
References: <1301455686-21517-1-git-send-email-panweiping3@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 22:44:54 -0500
Message-ID: <1301456694.3026.274.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 30 Mar 2011 03:44:55.0369 (UTC) FILETIME=[D56CA390:01CBEE8C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 11:28 +0800, Pan Weiping wrote:
> /home/pwp/mysvn/linux/linux-2.6/fs/xfs/linux-2.6/xfs_buf.c: In function
> ‘xfs_buf_readahead’:
> /home/pwp/mysvn/linux/linux-2.6/fs/xfs/linux-2.6/xfs_buf.c:660:27: warning:
> unused variable ‘bdi’
> Signed-off-by: Pan Weiping <panweiping3@gmail.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)

Thanks for sending this.  I already have a fix
in place.  I have not yet sent it to Linus yet
but will soon.

					-Alex

