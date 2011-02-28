Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1B1VTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:19:45 -0500
Received: from kroah.org ([198.145.64.141]:55170 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab1B1VTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:19:44 -0500
Date: Mon, 28 Feb 2011 13:19:02 -0800
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: RFC: [PATCH 3/5] staging: sep: add sep_crypto.h header
Message-ID: <20110228211902.GC8851@kroah.com>
References: <1298869892-4357-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298869892-4357-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 09:11:32PM -0800, Mark Allyn wrote:
> Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
> ---
>  drivers/staging/sep/sep_crypto.h |  315 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 315 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/sep/sep_crypto.h
> 
> diff --git a/drivers/staging/sep/sep_crypto.h b/drivers/staging/sep/sep_crypto.h
> new file mode 100644
> index 0000000..10a9425
> --- /dev/null
> +++ b/drivers/staging/sep/sep_crypto.h
> @@ -0,0 +1,315 @@
> +/*
> + *
> + *  sep_crypto.h - Crypto interface structures
> + *
> + *  Copyright(c) 2009,2011 Intel Corporation. All rights reserved.
> + *  Contributions(c) 2009,2010 Discretix. All rights reserved.
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under the terms of the GNU General Public License as published by the Free
> + *  Software Foundation; version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful, but WITHOUT
> + *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + *  more details.
> + *
> + *  You should have received a copy of the GNU General Public License along with
> + *  this program; if not, write to the Free Software Foundation, Inc., 59
> + *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.

Ah, you are signing up to track the business office of the FSF for the
next 40+ years and send me patches fixing this file?

Or, if not, don't include this paragraph.

{hint, don't do it...}

> + *  CONTACTS:
> + *
> + *  Mark Allyn		mark.a.allyn@intel.com
> + *  Jayant Mangalampalli jayant.mangalampalli@intel.com
> + *
> + *  CHANGES:
> + *
> + *  2009.06.26	Initial publish
> + *  2011.02.22  Enable Kernel Crypto

No changes in files.

thanks,

greg k-h
