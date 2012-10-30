Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab2J3TU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:20:29 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62850 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab2J3TUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:20:24 -0400
Date: Tue, 30 Oct 2012 12:20:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Behan Webster <behanw@converseincode.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Helper macros used for replacing the use of VLAIS
Message-ID: <20121030192021.GA1979@kroah.com>
References: <1351621520-17768-1-git-send-email-behanw@converseincode.com>
 <1351621520-17768-2-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351621520-17768-2-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 02:25:19PM -0400, Behan Webster wrote:
> The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
> precludes the use of compilers which don't implement VLAIS (for instance the
> Clang compiler). This new header file contains macros which can be used to
> calculate the size and offset of variables in an allocated buffer of memory
> taking into account alignment issues.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>  include/linux/valign.h |   87 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 87 insertions(+)
>  create mode 100644 include/linux/valign.h

You sent the same patch here, to two different trees (usb and
networking).  That's not good, what happens if they both apply them?

thanks,

greg k-h
