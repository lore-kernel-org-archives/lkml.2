Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab1HQTpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:45:11 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45283 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197Ab1HQTpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:45:09 -0400
Subject: Re: [PATCH] scsi: Document generic scsi device attributes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20110817182055.8848.75862.stgit@beardog.cce.hp.com>
References: <20110817182055.8848.75862.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 12:45:06 -0700
Message-ID: <1313610306.6345.4.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1+jejb.1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 13:20 -0500, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  Documentation/ABI/testing/sysfs-class-scsi_devices |  123 ++++++++++++++++++++
>  1 files changed, 123 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-scsi_devices
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-scsi_devices b/Documentation/ABI/testing/sysfs-class-scsi_devices
> new file mode 100644
> index 0000000..ad2d36b
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-scsi_devices
> @@ -0,0 +1,123 @@
> +What:           /sys/class/scsi_device/..../device/device_blocked
> +Date:           December, 2002
> +KernelVersion:  Unknown
> +Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>

Hmm, so I get fingered for every screw up in our sysfs ABI? nice wide
receiver buck pass move.

James


