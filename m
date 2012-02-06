Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2BFPHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:07:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38441 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2BFPHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:07:08 -0500
Date: Mon, 6 Feb 2012 09:06:58 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] toshiba_acpi: Expanded hotkey support
Message-ID: <20120206150658.GE6414@ubuntu-macmini>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>,
	linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
	Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
References: <1326915852-19896-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326915852-19896-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 01:44:07PM -0600, Seth Forshee wrote:
> Here's another round of the patches for expanded hotkey support for
> Toshibas addressing the problems raised in the last round. Changes since
> v2:
> 
>  * Use WMI GUID instead of DMI data to identify models with buggy INFO
>    implementations
>  * Add comment in makefile regarding link order requirement necessary
>    for the above

Matthew: Just wondering if there are more issues that need to be
addressed with this round of patches, or if they're looking okay at this
point.

Seth

> 
> Thanks,
> Seth
> 
> 
> Azael Avalos (1):
>   toshiba_acpi: Support additional hotkey scancodes
> 
> Seth Forshee (3):
>   ACPI: EC: Add ec_get_handle()
>   toshiba_acpi: Support alternate hotkey interfaces
>   toshiba_acpi: Refuse to load on machines with buggy INFO
>     implementations
> 
>  drivers/acpi/ec.c                   |   10 ++
>  drivers/platform/x86/Kconfig        |    1 +
>  drivers/platform/x86/Makefile       |    4 +
>  drivers/platform/x86/toshiba_acpi.c |  246 +++++++++++++++++++++++++++++-----
>  include/linux/acpi.h                |    1 +
>  5 files changed, 225 insertions(+), 37 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
