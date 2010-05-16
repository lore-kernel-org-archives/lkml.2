Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0EPHOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 03:14:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53504
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121Ab0EPHOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 03:14:54 -0400
Date: Sun, 16 May 2010 00:15:02 -0700 (PDT)
Message-Id: <20100516.001502.35836083.davem@davemloft.net>
To: tj@kernel.org
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, bzolnier@gmail.com
Subject: Re: [PATCH 2/8] block: restart partition scan after resizing a
 device
From: David Miller <davem@davemloft.net>
In-Reply-To: <1273946974-29131-3-git-send-email-tj@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	<1273946974-29131-3-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sat, 15 May 2010 20:09:28 +0200

> Device resize via ->set_capacity() can reveal new partitions (e.g. in
> chained partition table formats such as dos extended parts).  Restart
> partition scan from the beginning after resizing a device.  This
> change also makes libata always revalidate the disk after resize which
> makes lower layer native capacity unlocking implementation simpler and
> more robust as resize can be handled in the usual path.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Ben Hutchings <ben@decadent.org.uk>

Acked-by: David S. Miller <davem@davemloft.net>
