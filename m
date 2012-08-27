Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2H0UFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:05:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39145 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab2H0UFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:05:15 -0400
Date: Mon, 27 Aug 2012 13:05:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] workqueue: init 0 for idle_rebind.cnt
Message-ID: <20120827200510.GB14812@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
 <1346090307-3020-7-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346090307-3020-7-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 01:58:26AM +0800, Lai Jiangshan wrote:
> Access idle_rebind.cnt is always protected by gcwq->lock,
> don't need to init it as 1.

But then the completion could be triggered prematurely, no?

Thanks.

-- 
tejun
