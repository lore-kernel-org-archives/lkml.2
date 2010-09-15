Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab0IOIuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:50:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58809 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab0IOIuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:50:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio_blk: remove BKL leftovers
Date: Wed, 15 Sep 2010 10:50:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
References: <20100914232723.GA14175@lst.de>
In-Reply-To: <20100914232723.GA14175@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009151050.07833.arnd@arndb.de>
X-Provags-ID: V02:K0:iycSX+oIUPL/5YyDwKl4y6bJ0VIo83CUVh6uNpATfKp
 su0KCX22GJ801qRaUyK0J1HgjmNx1gt0hLTw2a5RS1j3NEPigL
 ZGG1k97MCp299XihZZ6iROS1ixnV/7QjUUDEk2iS1xqo2I7oDD
 TlBRf/U6/6KmSCDHLzpAXKNjURAbd8LcgDmGhmPTletO4wiyfY
 zEPhfWYhnm4FfBogOEwVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 September 2010, Christoph Hellwig wrote:
> Remove the BKL usage added in "block: push down BKL into .locked_ioctl".
> Virtio-blk doesn't use the BKL for anything, and doesn't implement any
> ioctl command by itself, but only uses the generic scsi_cmd_ioctl
> which is fine without the BKL.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Rusty, do you have a tree you want to stick this into?
If not, I can add it to my 'config' series' and drop my other patch
from the 'trivial' series.

	Arnd
