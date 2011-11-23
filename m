Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab1KWQXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:23:02 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35397 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1KWQXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:23:00 -0500
Date: Wed, 23 Nov 2011 08:22:54 -0800
From: Tejun Heo <tj@kernel.org>
To: Dave Young <dyoung@redhat.com>
Cc: xiyou.wangcong@gmail.com, kexec@lists.infradead.org, tim@edgecast.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: add comment to per_cpu_ptr_to_phys
Message-ID: <20111123162254.GD25780@google.com>
References: <20111123084543.GA2923@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123084543.GA2923@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 23, 2011 at 04:45:43PM +0800, Dave Young wrote:
> add comments about current per_cpu_ptr_to_phys implementation
> to explain why the logic is more complicated than necessary.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Moved the comment into the kerneldoc comment and applied to
percpu/for-3.2-fixes.

Thank you very much.

-- 
tejun
