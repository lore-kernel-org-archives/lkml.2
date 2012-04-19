Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2DSPRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 11:17:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36727 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211Ab2DSPRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 11:17:05 -0400
X-Sasl-enc: mGF04ptUmxqpPkiDWT/5iwxhluvCXfZxHhtklci1Ob4T 1334848624
Date: Thu, 19 Apr 2012 08:17:03 -0700
From: Greg KH <greg@kroah.com>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        artem.bityutskiy@linux.intel.com, shubhrajyoti@ti.com
Subject: Re: [PATCH 6/6] HSI: Add HSI ABI documentation
Message-ID: <20120419151703.GB31543@kroah.com>
References: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
 <1334837127-12931-7-git-send-email-carlos.chinea@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334837127-12931-7-git-send-email-carlos.chinea@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 03:05:27PM +0300, Carlos Chinea wrote:
> Adds sysfs HSI framework documentation
> 
> Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-hsi |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-hsi
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-hsi b/Documentation/ABI/testing/sysfs-bus-hsi
> new file mode 100644
> index 0000000..1b1b282
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-hsi
> @@ -0,0 +1,19 @@
> +What:		/sys/bus/hsi
> +Date:		April 2012
> +KernelVersion:	3.4
> +Contact:	Carlos Chinea <carlos.chinea@nokia.com>
> +Description:
> +		High Speed Synchronous Serial Interface (HSI) is a
> +		serial interface mainly used for connecting application
> +		engines (APE) with cellular modem engines (CMT) in cellular
> +		handsets.
> +		The bus will be populated with devices (hsi_clients) representing
> +		the protocols available in the system. Bus drivers implement
> +		those protocols.
> +
> +What:		/sys/bus/hsi/devices/.../modalias
> +Date:		April 2012
> +KernelVersion:	3.4
> +Contact:	Carlos Chinea <carlos.chinea@nokia.com>
> +Description:	Stores the same MODALIAS value emitted by uevent
> +		Format: hsi:<hsi_client device name>

You don't have any files in the device directories at all that you
create other than the modalias one?  If so, that's fine, just curious.

greg k-h
