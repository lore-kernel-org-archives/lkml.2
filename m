Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab0JUL2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:28:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43475
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757548Ab0JUL2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:28:50 -0400
Date: Thu, 21 Oct 2010 04:29:13 -0700 (PDT)
Message-Id: <20101021.042913.13752984.davem@davemloft.net>
To: tj@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2.6.36-rc7] net/neighbour: cancel_delayed_work() +
 flush_scheduled_work() -> cancel_delayed_work_sync()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CBDC19A.60709@kernel.org>
References: <4CBDC19A.60709@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Tue, 19 Oct 2010 18:04:42 +0200

> flush_scheduled_work() is going away.  Prepare for it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Applied.
