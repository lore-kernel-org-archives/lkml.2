Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab2CMIYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:24:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40505 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab2CMIY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:24:28 -0400
Message-ID: <4F5F0436.4010106@monstr.eu>
Date: Tue, 13 Mar 2012 09:24:22 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jiri Kosina <trivial@kernel.org>, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial next 4/9] microblaze: Use vsprintf extention %pf
 with builtin_return_address
References: <cover.1330454853.git.joe@perches.com> <a980a9c855113fd613ee768a503f5bd5299efafd.1330454853.git.joe@perches.com>
In-Reply-To: <a980a9c855113fd613ee768a503f5bd5299efafd.1330454853.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Emit the function name not the address when possible.
> 
> builtin_return_address() gives an address.  When building
> a kernel with CONFIG_KALLSYMS, emit the actual function
> name not the address.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/microblaze/mm/pgtable.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
