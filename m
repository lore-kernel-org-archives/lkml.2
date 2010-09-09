Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab0IIWmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:42:25 -0400
Received: from xenotime.net ([72.52.115.56]:37731 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932899Ab0IIWmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:42:17 -0400
Date: Thu, 9 Sep 2010 15:42:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 129/223]drivers/scsi/Kconfig Update broken web
 addresses.
Message-Id: <20100909154213.aefda094.rdunlap@xenotime.net>
In-Reply-To: <1284071862-8194-9-git-send-email-justinmattock@gmail.com>
References: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
	<1284071862-8194-9-git-send-email-justinmattock@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Sep 2010 15:37:36 -0700 Justin P. Mattock wrote:

> Below you will find an Update to a broken web address.
> Please let me know if this needs to be changed.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/scsi/Kconfig |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index bbf91ae..6fe68d0 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1608,9 +1608,9 @@ config SCSI_DEBUG
>  	  each with multiple dummy SCSI devices (disks). It defaults to one
>  	  host adapter with one dummy SCSI disk. Each dummy disk uses kernel
>  	  RAM as storage (i.e. it is a ramdisk). To save space when multiple
> -	  dummy disks are simulated, they share the same kernel RAM for 
> -	  their storage. See <http://www.torque.net/sg/sdebug.html> for more
> -	  information. This driver is primarily of use to those testing the
> +	  dummy disks are simulated, they share the same kernel RAM for their 
> +	  storage. See <http://web.archive.org/web/*/http://www.torque.net/sg/sdebug.html> 
> +	  for more information. This driver is primarily of use to those testing the
>  	  SCSI and block subsystems. If unsure, say N.

This one should be <http://sg.danny.cz/sg/sdebug26.html>

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
