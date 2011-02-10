Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1BJSG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:06:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab1BJSG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:06:27 -0500
Date: Thu, 10 Feb 2011 10:03:29 -0800
From: Greg KH <gregkh@suse.de>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, david@woodhou.se,
        david.woodhouse@intel.com
Subject: Re: [RFC PATCH 03/13] Intel(R) MEI Driver
Message-ID: <20110210180329.GF13795@suse.de>
References: <b7da2f$qd3ne6@fmsmga001.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7da2f$qd3ne6@fmsmga001.fm.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 01:55:03AM -0800, Oren Weil wrote:
> diff --git a/drivers/char/mei/Makefile b/drivers/char/mei/Makefile
> new file mode 100644
> index 0000000..a9ac1cb
> --- /dev/null
> +++ b/drivers/char/mei/Makefile
> @@ -0,0 +1,23 @@
> +#
> +# Kbuild - Intel(R) Management Engine Interface (Intel(R) MEI) Linux driver

This is not a Kbuild file, it's a Makefile file.

> +# Copyright (c) 2003-2011, Intel Corporation.

Really?  This file is originally based on 2003?  I find that very hard
to believe.

> +#
> +# This program is free software; you can redistribute it and/or modify it
> +# under the terms and conditions of the GNU General Public License,
> +# version 2, as published by the Free Software Foundation.

Makefiles are not "programs", please remove this from the Makefile, it
is not needed.

> +#
> +# This program is distributed in the hope it will be useful, but WITHOUT
> +# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> +# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> +# more details.

This paragraph is not needed.

> +#
> +# You should have received a copy of the GNU General Public License along with
> +# this program; if not, write to the Free Software Foundation, Inc.,
> +# 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.

NEVER put this paragraph in, unless you are going to be willing to
update the file every time the FSF moves office buildings for the rest
of your life.

greg k-h
