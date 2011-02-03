Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab1BCPtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:49:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:46028 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1BCPtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:49:43 -0500
Date: Thu, 3 Feb 2011 16:49:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Weber <weber@corscience.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 4/8] HID: roccat: Add support for Kova[+] mouse
In-Reply-To: <1296391104.2283.183.camel@neuromancer>
Message-ID: <alpine.LNX.2.00.1102031648490.2160@pobox.suse.cz>
References: <1296391104.2283.183.camel@neuromancer>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Jan 2011, Stefan Achatz wrote:

> This patch adds support for Roccat Kova[+] mouse.
> Userland tools can soon be found at http://sourceforge.net/projects/roccat
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  .../ABI/testing/sysfs-driver-hid-roccat-kovaplus   |   91 +++
>  drivers/hid/Kconfig                                |    8 +
>  drivers/hid/Makefile                               |    1 +
>  drivers/hid/hid-core.c                             |    1 +
>  drivers/hid/hid-ids.h                              |    1 +
>  drivers/hid/hid-roccat-kovaplus.c                  |  715 ++++++++++++++++++++
>  drivers/hid/hid-roccat-kovaplus.h                  |  157 +++++
>  7 files changed, 974 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
>  create mode 100644 drivers/hid/hid-roccat-kovaplus.c
>  create mode 100644 drivers/hid/hid-roccat-kovaplus.h
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
> new file mode 100644
> index 0000000..9e54af4
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
> @@ -0,0 +1,91 @@
> +What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_cpi
> +Date:		January 2011
> +Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
> +Description:	The integer value of this attribute ranges from 1-4.
> +		When read, this attribute returns the number of the active
> +		cpi level.
> +		This file is readonly.
> +

Stefan, one more things comes to my mind here.

Could you please post a followup patch with 'Users:' tag included in the 
sysfs documentation, pointing to the userspace application/library?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
