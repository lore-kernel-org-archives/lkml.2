Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166Ab2JYTQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:16:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42705 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760083Ab2JYTQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:16:26 -0400
Date: Thu, 25 Oct 2012 12:16:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Remove CsrEventHandle and functions using it
Message-ID: <20121025191622.GA4088@kroah.com>
References: <1351144271-24443-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351144271-24443-1-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 02:51:10PM +0900, SeongJae Park wrote:
> Nobody use CsrEventHandle, Nobody call function using it as parameter.
> So, remove it.
> 
> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
> ---
>  drivers/staging/csr/csr_framework_ext.h       |   61 -------------------------
>  drivers/staging/csr/csr_framework_ext_types.h |    2 -
>  2 files changed, 63 deletions(-)

This patch applies with fuzz, which implies that you didn't make it
against the latest tree.  Care to redo it, and the 2/2 patch, against
either my staging-next branch of the staging.git tree, or the next
linux-next release that will happen tomorrow, and resend them?

thanks,

greg k-h
