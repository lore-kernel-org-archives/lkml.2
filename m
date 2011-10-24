Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab1JXWfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:35:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39716 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751244Ab1JXWft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:35:49 -0400
Message-ID: <1319495747.2094.1.camel@Joe-Laptop>
Subject: Re: Update PMC Sierra MaxRAID MAINTAINERS entry
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 24 Oct 2011 15:35:47 -0700
In-Reply-To: <20111024221804.GB22671@redhat.com>
References: <20111024221804.GB22671@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-24 at 18:18 -0400, Dave Jones wrote:
> Anil's email no longer exists.
>  >    ----- The following addresses had permanent fatal errors -----
>  > <anil_ravindranath@pmc-sierra.com>
>  >     (reason: 550 5.1.1 <anil_ravindranath@pmc-sierra.com>: Recipient address rejected: User unknown in local recipient table)
> Signed-off-by: Dave Jones <davej@redhat.com>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6185d05..cfc47ee 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5038,7 +5038,6 @@ F:	drivers/hwmon/pmbus/
>  F:	include/linux/i2c/pmbus.h
>  
>  PMC SIERRA MaxRAID DRIVER
> -M:	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
>  L:	linux-scsi@vger.kernel.org
>  W:	http://www.pmc-sierra.com/
>  S:	Supported

Without an actual person as maintainer,
the S: entry should not be Supported.
Maybe "S:	Orphan" instead.


