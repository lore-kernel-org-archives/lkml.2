Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0LMLVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 06:21:40 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:46701 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab0LMLVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 06:21:39 -0500
Date: Mon, 13 Dec 2010 12:21:38 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/30] net/dsa: don't use flush_scheduled_work()
Message-ID: <20101213112138.GV15575@mail.wantstofly.org>
References: <1292086307-19211-1-git-send-email-tj@kernel.org> <1292086307-19211-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292086307-19211-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 05:51:22PM +0100, Tejun Heo wrote:

> flush_scheduled_work() is deprecated and scheduled to be removed.
> Directly flush dst->link_poll_work on remove instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Lennert Buytenhek <buytenh@wantstofly.org>

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
