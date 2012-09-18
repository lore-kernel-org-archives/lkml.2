Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2IRRlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 13:41:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42228 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab2IRRlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 13:41:08 -0400
Date: Tue, 18 Sep 2012 10:41:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [V2 for-next PATCH 2/2] workqueue: remove @delayed argument
 from cwq_dec_nr_in_flight()
Message-ID: <20120918174102.GD8474@google.com>
References: <1347947862-4533-1-git-send-email-laijs@cn.fujitsu.com>
 <1347947862-4533-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347947862-4533-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 01:57:34PM +0800, Lai Jiangshan wrote:
> The argument @delayed is always false in all call site,
> we simply remove it.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied 1-2 to wq/for-3.7 with comment / description updates.

Thanks.

-- 
tejun
