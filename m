Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab0ELCMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:12:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:1997 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab0ELCMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:12:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,211,1272870000"; 
   d="scan'208";a="517133120"
Subject: Re: ACPI Errors on Acer Aspire One
From: Zhang Rui <rui.zhang@intel.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTilF304TbgACKtvc_FA01uxHrdRBS2Q-o6Tm-n8Q@mail.gmail.com>
References: <AANLkTilF304TbgACKtvc_FA01uxHrdRBS2Q-o6Tm-n8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 10:12:53 +0800
Message-ID: <1273630373.22924.74.camel@rzhang1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 22:55 +0800, Jaswinder Singh Rajput wrote:
> Hello,
> 
> With latest git kernel, I am getting following ACPI errors :
> 
> [    0.289038] ACPI Error (dsfield-0143): [CAPB] Namespace lookup
> failure, AE_ALREADY_EXISTS
> [    0.289399] ACPI Error (psparse-0537): Method parse/execution
> failed [\_SB_.PCI0._OSC] (Node f70477e8), AE_ALREADY_EXISTS
> [    0.299684] ACPI Error (dsfield-0143): [CAPB] Namespace lookup
> failure, AE_ALREADY_EXISTS
> [    0.300007] ACPI Error (psparse-0537): Method parse/execution
> failed [\_SB_.PCI0._OSC] (Node f70477e8), AE_ALREADY_EXISTS
> 
> 
> dmesg : http://userweb.kernel.org/~jaswinder/acer_netbook/dmesg_2634-rc7.txt
> .config : http://userweb.kernel.org/~jaswinder/acer_netbook/config_2634-rc7.txt
> 
please attach the acpidump output.

It would be great if you can file a new bug report at
https://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
and attach the dmesg and acpidump there.

thanks,
rui

> How can I fix these errors.
> 
> Thanks,
> --
> Jaswinder Singh.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


