Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2FVSoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:44:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39524 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab2FVSoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:44:04 -0400
Date: Fri, 22 Jun 2012 11:43:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        Alex Lyashkov <umka@cloudlinux.com>
Subject: Re: [PATCH] Taint kernel when lve module is loaded
Message-ID: <20120622184359.GA25552@kroah.com>
References: <1340387371-32292-1-git-send-email-mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340387371-32292-1-git-send-email-mjg59@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 01:49:31PM -0400, Matthew Garrett wrote:
> Cloudlinux have a product called lve that includes a kernel module. This
> was previously GPLed but is now under a proprietary license, but the
> module continues to declare MODULE_LICENSE("GPL") and makes use of some
> EXPORT_SYMBOL_GPL symbols. Forcibly taint it in order to avoid this.
> 
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Alex Lyashkov <umka@cloudlinux.com>
> ---
>  kernel/module.c |    4 ++++
>  1 file changed, 4 insertions(+)

Do you have a pointer to this code anywhere?  Lying about the license to
the kernel is a pretty blatent thing to do and I'd like to have some
people follow up on that issue.

thanks,

greg k-h
