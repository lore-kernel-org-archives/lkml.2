Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab2J2V6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:58:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:50458 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793Ab2J2V6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:58:11 -0400
Date: Mon, 29 Oct 2012 14:58:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: csr: Remove CsrEventHandle
Message-ID: <20121029215809.GA19851@kroah.com>
References: <1351363525-17707-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351363525-17707-1-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 03:45:24AM +0900, SeongJae Park wrote:
> No one use CsrEventHandle, No one call functions using it as parameter.
> So those are not need to be here.
> 
> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
> ---
>  drivers/staging/csr/csr_framework_ext.h       |   61 -------------------------
>  drivers/staging/csr/csr_framework_ext_types.h |    2 -
>  2 files changed, 63 deletions(-)

Sorry, but someone already did this.  Look at the linux-next tree to see
the patch there that cleaned up part of this.  But, the second file you
changed here still applies, so can you redo this, and the 2/2 patch and
resend them?

thanks,

greg k-h
