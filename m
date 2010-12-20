Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0LTFx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 00:53:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33491
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087Ab0LTFxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 00:53:55 -0500
Date: Sun, 19 Dec 2010 21:54:23 -0800 (PST)
Message-Id: <20101219.215423.115923060.davem@davemloft.net>
To: jon.mason@exar.com
Cc: tj@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] vxge: add missing flush of reset_task
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101215142859.GA13516@exar.com>
References: <4D08CAB1.6040402@kernel.org>
	<20101215142859.GA13516@exar.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Mason <jon.mason@exar.com>
Date: Wed, 15 Dec 2010 08:29:00 -0600

> On Wed, Dec 15, 2010 at 06:03:29AM -0800, Tejun Heo wrote:
>> Commit 6e07ebd84 (drivers/net: remove unnecessary
>> flush_scheduled_work() calls) incorrectly removed the flush call
>> without replacing it with the appropriate work specific operation.
>> Fix it by flushing vdev->reset_task explicitly.
>> 
>> Pointed out by Jon Mason.
>> 
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Jon Mason <jon.mason@exar.com>
> Acked-by: Jon Mason <jon.mason@exar.com>

I'll apply this, thanks.
