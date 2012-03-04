Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2CDRhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 12:37:14 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64950 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab2CDRhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 12:37:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.224.230 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Sun, 4 Mar 2012 09:37:02 -0800
From: Tejun Heo <tj@kernel.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org,
        Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] percpu: fix __this_cpu_{sub,inc,dec}_return()
 definition
Message-ID: <20120304173702.GA20787@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120228204112.7816.24302.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120228204112.7816.24302.stgit@zurg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 12:41:12AM +0400, Konstantin Khlebnikov wrote:
> This patch adds missed "__" prefixes, otherwise these functions
> works as irq/preemption safe.
> 
> Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Applied to for-3.3-fixes.  Thank you.

-- 
tejun
