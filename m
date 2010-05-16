Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0EPHSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 03:18:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55786
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485Ab0EPHSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 03:18:18 -0400
Date: Sun, 16 May 2010 00:18:26 -0700 (PDT)
Message-Id: <20100516.001826.176644606.davem@davemloft.net>
To: tj@kernel.org
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, bzolnier@gmail.com
Subject: Re: [PATCH 7/8] libata: use the enlarged capacity after late HPA
 unlock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1273946974-29131-8-git-send-email-tj@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
	<1273946974-29131-8-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sat, 15 May 2010 20:09:33 +0200

> After late HPA unlock, libata kept using the original capacity
> ignoring the new larger native capacity.  Enlarging device on the fly
> doesn't cause any harm.  Use the larger native capacity instead.  This
> will enable on-demand HPA unlocking.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
