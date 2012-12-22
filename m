Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab2LVOPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 09:15:21 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58962 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2LVOPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 09:15:19 -0500
Message-ID: <1356185669.20841.9.camel@cumari.coelho.fi>
Subject: Re: [PATCH 09/25] wl1251: don't use [delayed_]work_pending()
From: Luciano Coelho <coelho@ti.com>
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Date: Sat, 22 Dec 2012 16:14:29 +0200
In-Reply-To: <1356141435-17340-10-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
	 <1356141435-17340-10-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 17:56 -0800, Tejun Heo wrote:
> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.
> 
> Remove unnecessary pending tests from wl1251.  Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Luciano Coelho <coelho@ti.com>
> Cc: linux-wireless@vger.kernel.org
> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.
> 
> Thanks.

It's probably easier if you take it via your tree.  This driver doesn't
get patches very often, so I doubt there will be any conflicts.

Thank you!

Acked-by: Luciano Coelho <coelho@ti.com>

--
Luca.

