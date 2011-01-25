Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1AYHSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 02:18:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57186
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231Ab1AYHSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 02:18:46 -0500
Date: Mon, 24 Jan 2011 23:19:21 -0800 (PST)
Message-Id: <20110124.231921.112591261.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, masa-korg@dsn.okisemi.com,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH] pch_gbe: don't use flush_scheduled_work()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110124143225.GF11404@htj.dyndns.org>
References: <20110124143225.GF11404@htj.dyndns.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Mon, 24 Jan 2011 15:32:25 +0100

> Directly cancel adapter->reset_task instead of using to-be-deprecated
> flush_scheduled_work().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Applied, thanks Tejun.
