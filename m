Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab2KVXCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 18:02:03 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:51929 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab2KVSag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:30:36 -0500
Message-ID: <50AD85C0.1010407@huawei.com>
Date: Thu, 22 Nov 2012 09:54:08 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Betty Dall <betty.dall@hp.com>
CC: <bhelgaas@google.com>, <jbarnes@virtuousgeek.org>,
        <alex.williamson@redhat.com>, <ddutile@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI: add PCIe 8.0 GT/s supported link speed define
References: <1353437939-29210-1-git-send-email-betty.dall@hp.com>
In-Reply-To: <1353437939-29210-1-git-send-email-betty.dall@hp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.84]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index 20ae747..0cf8abb 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -469,6 +469,7 @@
>  #define  PCI_EXP_LNKSTA_CLS	0x000f	/* Current Link Speed */
>  #define  PCI_EXP_LNKSTA_CLS_2_5GB 0x01	/* Current Link Speed 2.5GT/s */
>  #define  PCI_EXP_LNKSTA_CLS_5_0GB 0x02	/* Current Link Speed 5.0GT/s */
> +#define  PCI_EXP_LNKSTA_CLS_8_0GB 0x04	/* Current Link Speed 8.0GT/s */
>  #define  PCI_EXP_LNKSTA_NLW	0x03f0	/* Nogotiated Link Width */
>  #define  PCI_EXP_LNKSTA_NLW_SHIFT 4	/* start of NLW mask in link status */
>  #define  PCI_EXP_LNKSTA_LT	0x0800	/* Link Training */
> 

Hi Betty,
   There is another patch uses this PCI_EXP_LNKSTA_CLS_8_0GB ? I think maybe move this change to
the patch uses this symbol is better.

-- 
Thanks!
Yijing

