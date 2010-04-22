Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab0DVFdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 01:33:25 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:50508 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0DVFdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 01:33:23 -0400
Message-ID: <4BCFDF99.7090204@monstr.eu>
Date: Thu, 22 Apr 2010 07:33:13 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>, microblaze-uclinux@itee.uq.edu.au,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] microblaze: fix divide by zero exception message
References: <20100421141134.56eff2f5.randy.dunlap@oracle.com>
In-Reply-To: <20100421141134.56eff2f5.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix divide exception message to say "divide by zero".
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Michal Simek <monstr@monstr.eu>
> Cc:	microblaze-uclinux@itee.uq.edu.au
> ---
>  arch/microblaze/kernel/exceptions.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
