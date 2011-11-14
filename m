Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab1KNCPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 21:15:41 -0500
Received: from lo.gmane.org ([80.91.229.12]:50029 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab1KNCPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 21:15:40 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] kdump: Add missing RAM resource in
 crash_shrink_memory()
Date: Mon, 14 Nov 2011 02:15:19 +0000 (UTC)
Message-ID: <j9ptjm$hr5$1@dough.gmane.org>
References: <1320228143.2776.12.camel@br98xy6r>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 180.129.196.69
User-Agent: Pan/0.133 (House of Butterflies)
Cc: kexec@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Nov 2011 11:02:23 +0100, Michael Holzheu wrote:

> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> When shrinking crashkernel memory using /sys/kernel/kexec_crash_size for
> the newly added memory no RAM resource is created at the moment.
> 
...
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

