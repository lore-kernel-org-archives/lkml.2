Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab2JHApM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 20:45:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38137 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2JHApI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 20:45:08 -0400
Date: Sun, 7 Oct 2012 17:45:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, akpm@linux-foundation.org, andi@firstfloor.org
Subject: Re: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
Message-ID: <20121008004504.GB12342@kroah.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
 <1349654386-18378-1-git-send-email-kys@microsoft.com>
 <1349654386-18378-2-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349654386-18378-2-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 04:59:46PM -0700, K. Y. Srinivasan wrote:
> +config HYPERV_BALLOON
> +	tristate "Microsoft Hyper-V Balloon driver"
> +	depends on HYPERV
> +	help
> +	  Select this option to enable the Hyper-V Utilities.

Your help text is wrong :(

> --- /dev/null
> +++ b/drivers/hv/hv_balloon.c
> @@ -0,0 +1,1043 @@
> +/*
> + * Copyright (c) 2012, Microsoft Corporation.
> + *
> + * Author:
> + *   K. Y. Srinivasan <kys@microsoft.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + * NON INFRINGEMENT.  See the GNU General Public License for more
> + * details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.

Unless you promise to keep track of the FSF's office buildings for the
next 40+ years, just drop this paragraph entirely.

greg k-h
