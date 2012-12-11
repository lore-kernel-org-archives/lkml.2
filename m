Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2LKPaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 10:30:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52126 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab2LKPaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 10:30:17 -0500
Date: Tue, 11 Dec 2012 07:30:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [GIT PULL] percpu changes for v3.8
Message-ID: <20121211153012.GH7084@htj.dyndns.org>
References: <20121211142453.GD7084@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211142453.GD7084@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 06:24:53AM -0800, Tejun Heo wrote:
> Hello, Linus.
> 
> Percpu changes for v3.8.  Nothing exciting here either.  Joonsoo's is
> almost cosmetic.  Cyrill's patch fixes "percpu_alloc" early kernel
> param handling so that the kernel doesn't crash when the parameter is
> specified w/o any argument.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-next

Oops, for-next and for-3.8 point to the same commit, so either should
work but this shoul have been,

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.8

Thanks.

-- 
tejun
