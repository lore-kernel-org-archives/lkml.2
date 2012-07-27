Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab2G0TB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:01:27 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:60748 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab2G0TBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:01:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC] PCI/PM: Add ABI document for sysfs file d3cold_allowed
Date: Fri, 27 Jul 2012 21:07:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Bjorn Mork <bjorn@mork.no>
References: <1343376454-28520-1-git-send-email-ying.huang@intel.com>
In-Reply-To: <1343376454-28520-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207272107.11080.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 27, 2012, Huang Ying wrote:
> This patch adds ABI document for the following sysfs file:
> 
> /sys/bus/pci/devices/.../d3cold_allowed
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  Documentation/ABI/testing/sysfs-bus-pci |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -210,3 +210,15 @@ Users:
>  		firmware assigned instance number of the PCI
>  		device that can help in understanding the firmware
>  		intended order of the PCI device.
> +
> +What:		/sys/bus/pci/devices/.../d3cold_allowed
> +Date:		July 2012
> +Contact:	Huang Ying <ying.huang@intel.com>
> +Description:
> +		d3cold_allowed is bit to control whether the corresponding PCI
> +		device can be put into D3Cold state.  If it is cleared, the
> +		device will never be put into D3Cold state.  If it is set, the
> +		device may be put into D3Cold state if other requirement are
> +		satisfied too.  Reading this attribute will show the current
> +		value of d3cold_allowed bit.  Writting this attribute will set
> +		the value of d3cold_allowed bit.
> 
> 

