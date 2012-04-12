Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934844Ab2DLVyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:54:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934842Ab2DLVyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:54:39 -0400
Date: Thu, 12 Apr 2012 23:54:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH] Cleanup of rw_copy_check_uvector and
	compat_rw_copy_check_uvector
Message-ID: <20120412215410.GB31852@redhat.com>
References: <20120411210604.26d04483@Gantu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411210604.26d04483@Gantu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11, Christopher Yeoh wrote:
>
> Resending this patch which I first sent a couple of months ago and
> didn't notice it didn't go in at the time.
>
> This is the cleanup of rw_copy_check_uvector and
> compat_rw_copy_check_uvector after changes made to support CMA in an
> earlier patch. Rather than having an additional check_access parameter
> to these functions, the first paramater type is overloaded to allow the
> caller to specify CHECK_IOVEC_ONLY which means check that the contents
> of the iovec are valid, but do not check the memory that they point to.
> This is used by process_vm_readv/writev where we need to validate that a
> iovec passed to the syscall is valid but do not want to check the
> memory that it points to at this point because it refers to an address
> space in another process.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

