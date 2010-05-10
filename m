Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab0EJFNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:13:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35582 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab0EJFNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:13:51 -0400
Message-ID: <4BE79526.5040603@zytor.com>
Date: Sun, 09 May 2010 22:09:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
References: <20100510144907.fb4caea9.sfr@canb.auug.org.au>
In-Reply-To: <20100510144907.fb4caea9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2010 09:49 PM, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/misc/vmware_balloon.c:44:24: error: asm/vmware.h: No such file or directory
> drivers/misc/vmware_balloon.c: In function 'vmballoon_init':
> drivers/misc/vmware_balloon.c:770: error: implicit declaration of function 'vmware_platform'
> 
> Caused by commit e08cae4181af9483b04ecfac48f01c8e5a5f27bf ("x86: Clean up
> the hypervisor layer").  (Yes, I know this has already been reported.)
> 
> I have used the version of the tip tree from next-20100507 for today.

Working on it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

