Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab2IZNZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:25:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43384 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab2IZNZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:25:53 -0400
Date: Wed, 26 Sep 2012 06:25:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tao Guo <glorioustao@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
        Ingo Molnar <mingo@elte.hu>, stable@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86_64: Work around old gas bug
Message-ID: <20120926132549.GA23630@kroah.com>
References: <1348648102-12653-1-git-send-email-glorioustao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348648102-12653-1-git-send-email-glorioustao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 04:28:22AM -0400, Tao Guo wrote:
> gas in binutils(2.16.91) could not parse parentheses within macro
> parameters unless fully parenthesized, and this is a workaround to
> make old gas work without generating below errors:
> arch/x86/kernel/entry_64.S: Assembler messages:
> arch/x86/kernel/entry_64.S:387: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:389: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:390: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:391: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:392: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:393: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:394: Error: too many positional arguments
> 
> Signed-off-by: Tao Guo <glorioustao@gmail.com>
> ---
>  arch/x86/include/asm/calling.h |   48 +++++++++++++++++++--------------------
>  arch/x86/kernel/entry_64.S     |   20 ++++++++--------
>  2 files changed, 33 insertions(+), 35 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
