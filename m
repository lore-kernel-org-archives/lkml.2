Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1AEMti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 07:49:38 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37270 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab1AEMth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 07:49:37 -0500
Message-ID: <4D24689B.5040209@ru.mvista.com>
Date: Wed, 05 Jan 2011 15:48:27 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH linux-next-2.6] pch_udc: support new device ML7213 IOH
References: <1294226550-4788-1-git-send-email-tomoya-linux@dsn.okisemi.com>
In-Reply-To: <1294226550-4788-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05-01-2011 14:22, Tomoya MORINAGA wrote:

> Support new device OKI SEMICONDUCTOR's ML7213 IOH(Input/Output Hub) which is for
> IVI(In-Vehicle Infotainment) use.
> The ML7213 is companion chip for Intel Atom E6xx series.
> The ML7213 is completely compatible for Intel EG20T PCH.

> Signed-off-by: Tomoya MORINAGA<tomoya-linux@dsn.okisemi.com>
[...]

> diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
> index 0c8dd81..cab47d6 100644
> --- a/drivers/usb/gadget/pch_udc.c
> +++ b/drivers/usb/gadget/pch_udc.c
> @@ -361,6 +361,8 @@ struct pch_udc_dev {
>
>   #define PCH_UDC_PCI_BAR			1
>   #define PCI_DEVICE_ID_INTEL_EG20T_UDC	0x8808
> +#define PCI_VENDOR_ID_ROHM 0x10DB
> +#define PCI_DEVICE_ID_ML7213_IOH_UDC	0x801D

    Please align the macro values with the above one.

WBR, Sergei
