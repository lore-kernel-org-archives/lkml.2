Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1ISOWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 10:22:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab1ISOWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 10:22:17 -0400
Date: Mon, 19 Sep 2011 11:21:53 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zhao Jin <cronozhj@gmail.com>
Cc: avi@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm, mmu: fix incorrect return of spte
Message-ID: <20110919142153.GA6356@amt.cnet>
References: <1316405991-14903-1-git-send-email-cronozhj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316405991-14903-1-git-send-email-cronozhj@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 12:19:51PM +0800, Zhao Jin wrote:
> __update_clear_spte_slow should return original spte while the
> current code returns low half of original spte combined with high
> half of new spte.
> 
> Signed-off-by: Zhao Jin <cronozhj@gmail.com>
> ---
>  arch/x86/kvm/mmu.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Applied, thanks.

