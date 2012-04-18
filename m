Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab2DRSac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:30:32 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:47637 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575Ab2DRSaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:30:00 -0400
From: Kevin Hilman <khilman@ti.com>
To: jean.pihet@newoldbits.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH v2 0/9] PM: Create the AVS class of drivers
Organization: Texas Instruments, Inc.
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
Date: Wed, 18 Apr 2012 11:30:00 -0700
In-Reply-To: <1332173578-27422-1-git-send-email-j-pihet@ti.com> (jean pihet's
	message of "Mon, 19 Mar 2012 17:12:49 +0100")
Message-ID: <878vhski53.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

jean.pihet@newoldbits.com writes:

> From: Jean Pihet <j-pihet@ti.com>
>
> AVS is a power management technique which controls the operating
> voltage of a device in order to optimize (i.e. reduce) its power
> consumption. The voltage is adapted depending on static factors
> (chip manufacturing process) and dynamic factors (temperature
> depending performance).
> AVS is also called SmartReflex on OMAP devices.
>
> To that end, create the AVS framework in drivers/power/avs and
> move the OMAP SmartReflex code to the new directory.

I've done a review of this series and had a few very minor comments.

Once those are addressed, are you OK with us moving this AVS driver
under drivers/power?

Thanks,

Kevin

