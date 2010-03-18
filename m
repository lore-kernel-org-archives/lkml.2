Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0CRXAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 19:00:20 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:16426 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab0CRXAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 19:00:18 -0400
Message-ID: <4BA2B028.8060705@oracle.com>
Date: Thu, 18 Mar 2010 15:58:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/pci/pci.c Section mismatch
References: <4BA2A46E.5090008@googlemail.com>
In-Reply-To: <4BA2A46E.5090008@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BA2B07F.0046:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/10 15:08, René Bolldorf wrote:
> Signed-off-by: Rene Bolldorf <xsecute@googlemail.com>
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index ddd55dc..a1f7d93 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2773,7 +2773,7 @@ int pci_resource_bar(struct pci_dev *dev, int
> resno, enum pci_bar_type *type)
>  /* Some architectures require additional programming to enable VGA */
>  static arch_set_vga_state_t arch_set_vga_state;
> 
> -void __init pci_register_set_vga_state(arch_set_vga_state_t func)
> +void pci_register_set_vga_state(arch_set_vga_state_t func)
>  {
>      arch_set_vga_state = func;    /* NULL disables */
>  }
> -- 

Hi,

Please put the offending/warning messages in the patch description.
Include your analysis if it isn't obvious.

thanks,
-- 
~Randy
