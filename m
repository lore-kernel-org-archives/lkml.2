Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab2J0PGa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 11:06:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39039 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab2J0PG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 11:06:29 -0400
Date: Sat, 27 Oct 2012 08:07:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yan Hong <clouds.yan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@gnudd.com>
Subject: Re: [PATCH 1/5] debugfs: pass NULL as the last parameter of
 debugfs_print_regs32()
Message-ID: <20121027150715.GD3349@kroah.com>
References: <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351325129-10097-1-git-send-email-clouds.yan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 04:05:25PM +0800, Yan Hong wrote:
> If 'prefix' is not used, pass NULL instead of empty string as the
> last parameter of debugfs_print_regs32().
> 
> Cc: Alessandro Rubini <rubini@gnudd.com>
> 
> Signed-off-by: Yan Hong <clouds.yan@gmail.com>
> ---
> 
> This function is only used (twice) by the author of it, and the
> 'prefix' feature is never used. But it's a well-documented debugfs
> API. It's added one year ago and appeared in many documents. I still
> prefer to let this API stay unchanged and treat the empty string as
> typo.

What "documents" did this appear in?  If the parameter isn't being used,
please, just delete it.

greg k-h
