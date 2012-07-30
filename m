Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2G3SED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 14:04:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab2G3SD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 14:03:59 -0400
Message-ID: <5016CC75.3050806@redhat.com>
Date: Mon, 30 Jul 2012 14:03:33 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Mork <bjorn@mork.no>
Subject: Re: [RFC] PCI/PM: Add ABI document for sysfs file d3cold_allowed
References: <1343376454-28520-1-git-send-email-ying.huang@intel.com>
In-Reply-To: <1343376454-28520-1-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2012 04:07 AM, Huang Ying wrote:
> This patch adds ABI document for the following sysfs file:
>
> /sys/bus/pci/devices/.../d3cold_allowed
>
> Signed-off-by: Huang Ying<ying.huang@intel.com>
> ---
>   Documentation/ABI/testing/sysfs-bus-pci |   12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -210,3 +210,15 @@ Users:
>   		firmware assigned instance number of the PCI
>   		device that can help in understanding the firmware
>   		intended order of the PCI device.
> +
> +What:		/sys/bus/pci/devices/.../d3cold_allowed
> +Date:		July 2012
> +Contact:	Huang Ying<ying.huang@intel.com>
> +Description:
> +		d3cold_allowed is bit to control whether the corresponding PCI
> +		device can be put into D3Cold state.  If it is cleared, the
> +		device will never be put into D3Cold state.  If it is set, the
> +		device may be put into D3Cold state if other requirement are
did you mean 'requirements' here? -------------------------------^
or is there only 1 other requirement?

> +		satisfied too.  Reading this attribute will show the current
> +		value of d3cold_allowed bit.  Writting this attribute will set
spell checker says 'Writing' --------------------^

> +		the value of d3cold_allowed bit.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

