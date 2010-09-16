Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0IPFxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 01:53:09 -0400
Received: from ozlabs.org ([203.10.76.45]:54469 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab0IPFxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 01:53:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio_blk: remove BKL leftovers
Date: Thu, 16 Sep 2010 15:22:52 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
References: <20100914232723.GA14175@lst.de>
In-Reply-To: <20100914232723.GA14175@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009161522.53064.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 08:57:23 am Christoph Hellwig wrote:
> Remove the BKL usage added in "block: push down BKL into .locked_ioctl".
> Virtio-blk doesn't use the BKL for anything, and doesn't implement any
> ioctl command by itself, but only uses the generic scsi_cmd_ioctl
> which is fine without the BKL.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Applied,
Thanks!
Rusty.
