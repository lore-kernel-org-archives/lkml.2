Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1LTEUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 23:20:55 -0500
Received: from ozlabs.org ([203.10.76.45]:49961 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab1LTEUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 23:20:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the rr tree
In-Reply-To: <20111220133927.f74f564f566166253bcef211@canb.auug.org.au>
References: <20111220133927.f74f564f566166253bcef211@canb.auug.org.au>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 20 Dec 2011 14:24:10 +1030
Message-ID: <87y5u7dhjx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011 13:39:27 +1100, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
Non-text part: multipart/signed
> Hi Rusty,
> 
> After merging the rr tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:

Thanks, I missed the header declaration.  Fixed.

Cheers,
Rusty.
