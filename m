Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423011Ab2CPPTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:19:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42432 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422813Ab2CPPTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:19:50 -0400
Date: Fri, 16 Mar 2012 08:19:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] tty/hvc_vio: FW_FEATURE_ISERIES is no longer
 selectable
Message-ID: <20120316151946.GE28696@kroah.com>
References: <20120316151459.dab3cdcc2d5984b05e2d2b5c@canb.auug.org.au>
 <20120316151654.7b2fedd2ecd2132a807630c6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120316151654.7b2fedd2ecd2132a807630c6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 03:16:54PM +1100, Stephen Rothwell wrote:
> so remove the code that tests for it.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/tty/hvc/hvc_vio.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> Greg, it is probably easiest for this to go through the powerpc tree.

Please do:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

