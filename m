Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab1CSSUE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 14:20:04 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:33117 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab1CSSUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 14:20:01 -0400
Date: Sat, 19 Mar 2011 23:49:54 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: greg@kroah.com
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, anton@samba.org,
        benh@kernel.crashing.org, mananth@in.ibm.com
Subject: Re: [0/3] 2.6.32.stable kexec/kdump fixes backport series
Message-ID: <20110319181954.GE23832@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20110319180811.GA23832@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110319180811.GA23832@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> [2011-03-19 23:38:11]:

> Hi Greg,
> 
> 	Can you please merge the following kexec/kdump backports for
> 2.6.32-stable of current upstream commits. They are bug fixes,
> which are needed in the 2.6.23-stable tree.
  Sorry for the typo ^^^^^^^^^^^^^^^^^^, these bug fixes
are required in 2.6.32-stable tree.
> 
> Michael Neuling (2):
>  powerpc/kexec: Fix race in kexec shutdown
>  powerpc/kdump: Fix race in kdump shutdown
> 
> Milton Miller (1):
>  powerpc: rtas_flash needs to use rtas_data_buf
> 
> arch/powerpc/include/asm/kexec.h       |    4 ++
> arch/powerpc/include/asm/paca.h        |    3 +-
> arch/powerpc/kernel/asm-offsets.c      |    1 +
> arch/powerpc/kernel/crash.c            |   28 ++++++++++++++++++
> arch/powerpc/kernel/machine_kexec_64.c |   48 ++++++++++++++++++++++---------
> arch/powerpc/kernel/misc_64.S          |    8 +++--
> arch/powerpc/kernel/paca.c             |    2 +
> arch/powerpc/kernel/rtas_flash.c       |   41 ++++++++++++++------------
>    8 files changed, 98 insertions(+), 37 deletions(-)
> 
> 			
> 			Kamalesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
			
			Kamalesh
