Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767Ab0JVTNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:13:34 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51562 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759732Ab0JVTN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:13:29 -0400
Subject: Re: BUG with the kernel version 2.6.36-rc1 on power machine
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Linuxppc-dev <Linuxppc-dev@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
        divya <dipraksh@linux.vnet.ibm.com>
In-Reply-To: <AANLkTikmpohofzO_dV_Dv8EfcEMsyy4cdhGMUD-PAFO3@mail.gmail.com>
References: <4CC13B2C.7090908@linux.vnet.ibm.com>
	 <4CC13FFF.7040200@linux.vnet.ibm.com>
	 <AANLkTikmpohofzO_dV_Dv8EfcEMsyy4cdhGMUD-PAFO3@mail.gmail.com>
Content-Type: text/plain
Organization: IBM
Date: Sat, 23 Oct 2010 00:43:21 +0530
Message-Id: <1287774802.19497.1.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is equally seen for both Power6 and Power7 machines.

Regards--
Subrata

On Sat, 2010-10-23 at 00:37 +0530, Subrata Modak wrote:
> 
> 
> ---------- Forwarded message ----------
> From: divya <dipraksh@linux.vnet.ibm.com>
> Date: Fri, Oct 22, 2010 at 1:10 PM
> Subject: Re: BUG with the kernel version 2.6.36-rc1 on power machine
> To: LKML <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
> linuxppc-dev@ozlabs.org
> 
> 
> 
> On Friday 22 October 2010 12:50 PM, divya wrote:
>         Hi ,
>         
>         With the latest version of kernel 2.6.36-rc1 running on the
>         power machine, came across the following call trace
>         
>         BUG: looking up invalid subclass: 31
>         turning off the locking correctness validator.
>         Call Trace:
>         [c00000000e0bfb60] [c0000000000119a0] .show_stack+0x6c/0x16c
>         (unreliable)
>         [c00000000e0bfc10] [c0000000000c39b8] .lockdep_init_map
>         +0x194/0x630
>         [c00000000e0bfcf0] [c0000000005524f8] .mousedev_create
>         +0xcc/0x234
>         [c00000000e0bfda0] [c00000000093fb58] .mousedev_init+0x38/0xa0
>         [c00000000e0bfe30] [c0000000000097e4] .do_one_initcall
>         +0xd8/0x1c8
>         [c00000000e0bfee0] [c0000000009004ac] .kernel_init+0x23c/0x2f8
>         [c00000000e0bff90] [c00000000002ad30] .kernel_thread+0x54/0x70
>         
>         The config file used for make oldconfig is being attached
>         
>         Thanks
>         Divya
>         
>         
>         
>         
> I meant 2.6.36-git1(b5153163ed580e) , and not 2.6.36-rc1.
> Sorry for the confusion.
> 
> Thanks
> Divya
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> 
> -- 
> Regards & Thanks--
> Subrata

