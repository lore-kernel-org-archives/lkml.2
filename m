Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1JLOxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:53:37 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56155 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab1JLOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:53:33 -0400
X-Sasl-enc: c5DhUmoaDy3Xhroxss82zo1N0PRs1S6w8diKGwxGhHmX 1318431211
Date: Wed, 12 Oct 2011 08:53:08 -0600
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the staging tree with the tip tree
Message-ID: <20111012145308.GA18777@kroah.com>
References: <20111012163452.7f1822bb8dca107daf26d28b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012163452.7f1822bb8dca107daf26d28b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 04:34:52PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/hv/Makefile between commit 6f4151c89b7d ("x86: Hyper-V:
> Integrate the clocksource with Hyper-V detection code") from the tip tree
> and commit 46a971913611 ("Staging: hv: move hyperv code out of staging
> directory") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

The fix looks correct, thanks.

greg k-h
