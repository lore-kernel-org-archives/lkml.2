Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab0KARmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:42:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab0KARmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:42:08 -0400
Date: Mon, 1 Nov 2010 15:19:49 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Alexander Graf <agraf@suse.de>,
        Avi Kivity <avi@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: kvm: fix information leak to userland
Message-ID: <20101101171949.GB4484@amt.cnet>
References: <1288429464-21763-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288429464-21763-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 01:04:24PM +0400, Vasiliy Kulikov wrote:
> Structure kvm_ppc_pvinfo is copied to userland with flags and
> pad fields unitialized.  It leads to leaking of contents of
> kernel stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  I cannot compile this driver, so it is not tested at all.
> 
>  arch/powerpc/kvm/powerpc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Applied, thanks.

