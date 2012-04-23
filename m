Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2DWWSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:18:21 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56244 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070Ab2DWWST convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:18:19 -0400
MIME-Version: 1.0
In-Reply-To: <1335198236-3183-1-git-send-email-seth.heasley@intel.com>
References: <1335198236-3183-1-git-send-email-seth.heasley@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 23 Apr 2012 16:17:57 -0600
Message-ID: <CAErSpo5XN2f-Xg6QgkqQDr-UBOLg2aQ6ZuhrCGv6KMxSat6=Tw@mail.gmail.com>
Subject: Re: [PATCH 1/3] pci_ids: Add Intel Centerton Legacy Block DeviceID
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 10:23 AM, Seth Heasley <seth.heasley@intel.com> wrote:
> This patch adds the Integrated Legacy Block DeviceID for the Centerton CPU.  It will be used in the GPIO and Multifunction Devices driver.
>
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> ---
> Adding Samuel Ortiz, because a subsequent multifunction device patch references this one.
>
>  include/linux/pci_ids.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 3329965..ab741b0 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2506,6 +2506,7 @@
>  #define PCI_DEVICE_ID_INTEL_MRST_SD2   0x084F
>  #define PCI_DEVICE_ID_INTEL_I960       0x0960
>  #define PCI_DEVICE_ID_INTEL_I960RM     0x0962
> +#define PCI_DEVICE_ID_INTEL_CENTERTON_ILB      0x0c60
>  #define PCI_DEVICE_ID_INTEL_8257X_SOL  0x1062
>  #define PCI_DEVICE_ID_INTEL_82573E_SOL 0x1085
>  #define PCI_DEVICE_ID_INTEL_82573L_SOL 0x108F

I assume, based on your LKML exchange with Samuel, that you don't need
me to do anything in PCI with this.

Bjorn
