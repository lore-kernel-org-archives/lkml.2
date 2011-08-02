Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab1HBTIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:08:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab1HBTIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:08:31 -0400
Date: Tue, 2 Aug 2011 13:44:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Julia Lawall <julia@diku.dk>
Cc: Avi Kivity <avi@redhat.com>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/11] arch/x86/kvm/vmx.c: trivial: use BUG_ON
Message-ID: <20110802164412.GC5144@amt.cnet>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
 <1312281304-11847-5-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312281304-11847-5-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 12:34:57PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use BUG_ON(x) rather than if(x) BUG();
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@ identifier x; @@
> -if (x) BUG();
> +BUG_ON(x);
> 
> @@ identifier x; @@
> -if (!x) BUG();
> +BUG_ON(!x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks.

