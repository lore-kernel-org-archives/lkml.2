Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768106Ab2KOOxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:53:31 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37788 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768070Ab2KOOx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:53:29 -0500
Date: Thu, 15 Nov 2012 06:53:25 -0800
From: Tejun Heo <htejun@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        Shan Wei <shanwei88@gmail.com>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9 v4] use efficient this_cpu_* helper
Message-ID: <20121115145325.GC7306@mtj.dyndns.org>
References: <50A1A7A9.6050501@gmail.com>
 <0000013b047079ab-01971b64-07e2-4f2e-a204-6baff2180fc3-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013b047079ab-01971b64-07e2-4f2e-a204-6baff2180fc3-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 02:19:38PM +0000, Christoph Lameter wrote:
> Tejon: Could you pick up this patchset?

Sure, but, Shan, when posting patchset, please make the patches
replies to the head message; otherwise, it's pretty difficult to track
what's going on with the patchset as a whole.  I see that some patches
are being picked up by respective subsystems.  If you have patches
left, please let me know.

Thanks.

-- 
tejun
