Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab0LIP4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:56:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab0LIP4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:56:53 -0500
Date: Thu, 9 Dec 2010 10:20:33 -0500
From: Don Zickus <dzickus@redhat.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] x86: Fix warning in hw_nmi.c
Message-ID: <20101209152033.GU21786@redhat.com>
References: <AANLkTi=rcc38QzoKa6LFy4m++-p_9=Zt4_kDQE=GeKxf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=rcc38QzoKa6LFy4m++-p_9=Zt4_kDQE=GeKxf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 02:47:34PM +0600, Rakib Mullick wrote:
> commit 0e2af2a9abf94b408ff70679b692a8644fed4aab fixed this warning, it
> again introduced by commit 5f2b0ba4d94b3ac23cbc4b7f675d98eb677a760a.
> This patch fixes it by moving arch_trigger_all_cpu_backtrace few lines
> above backtrace_mask's declaration.
> 
> We were warned by the following warning:
> 
> arch/x86/kernel/apic/hw_nmi.c:29: warning: ‘backtrace_mask’ defined but not used
> 
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

Thanks Rakib.

I already have this fix lined up for Ingo in another patch series.

http://thread.gmane.org/gmane.linux.kernel/1069682/focus=1069960

Hopefully Ingo will get a chance to include it soon.

Cheers,
Don
