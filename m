Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab0KBUUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 16:20:23 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40262 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0KBUUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 16:20:20 -0400
Date: Tue, 2 Nov 2010 13:20:15 -0700
From: Vernon Mauery <vernux@us.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Keith Mannthey <kmannth@us.ibm.com>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH -resend] ibm_rtl: fix printk format warning
Message-ID: <20101102202015.GJ4850@lucy>
References: <1288728491-2216-1-git-send-email-vernux@us.ibm.com>
 <20101102131742.313f7fbf.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20101102131742.313f7fbf.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02-Nov-2010 01:17 PM, Randy Dunlap wrote:
>From: Randy Dunlap <randy.dunlap@oracle.com>
>
>Fix printk format warning:
>
>drivers/platform/x86/ibm_rtl.c:305:warning: format '%#llx' expects type 'long long unsigned int', but argument 2 has type 'phys_addr_t'
>
>Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>Cc: Keith Mannthey <kmannth@us.ibm.com>
>Cc: Vernon Mauery <vernux@us.ibm.com>
>Cc: platform-driver-x86@vger.kernel.org
>Cc: Matthew Garrett <mjg@redhat.com>

Acked-by: Vernon Mauery <vernux@us.ibm.com>

--Vernon

>---
> drivers/platform/x86/ibm_rtl.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>--- linux-next-20101022.orig/drivers/platform/x86/ibm_rtl.c
>+++ linux-next-20101022/drivers/platform/x86/ibm_rtl.c
>@@ -302,7 +302,7 @@ static int __init ibm_rtl_init(void) {
> 			RTL_DEBUG("rtl_cmd_width = %u, rtl_cmd_type = %u\n",
> 			      rtl_cmd_width, rtl_cmd_type);
> 			addr = ioread32(&rtl_table->cmd_port_address);
>-			RTL_DEBUG("addr = %#llx\n", addr);
>+			RTL_DEBUG("addr = %#llx\n", (unsigned long long)addr);
> 			plen = rtl_cmd_width/sizeof(char);
> 			rtl_cmd_addr = rtl_port_map(addr, plen);
> 			RTL_DEBUG("rtl_cmd_addr = %#llx\n", (u64)rtl_cmd_addr);
>
