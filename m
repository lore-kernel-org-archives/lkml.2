Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab2DSRDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:03:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49741 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab2DSRDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:03:24 -0400
Message-ID: <4F904541.2030200@zytor.com>
Date: Thu, 19 Apr 2012 10:02:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
References: <1334794610-5546-1-git-send-email-hpa@zytor.com> <20120419092255.GA29542@aftab> <20120419092630.GD29542@aftab>
In-Reply-To: <20120419092630.GD29542@aftab>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 02:26 AM, Borislav Petkov wrote:
> 
> Also, move the sorting of the main exception table earlier in the boot
> process now that we handle exceptions in the early IDT handler too.
> 

I would much rather use David Daney's patchset to sort the exception
table at compile time:

	https://lkml.org/lkml/2011/11/18/427

... and I would be *even happier* with an O(1) hash (which pretty much
*have* to be constructed at compile time.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

