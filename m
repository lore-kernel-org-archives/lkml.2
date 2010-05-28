Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab0E1QqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 12:46:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47321 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999Ab0E1QqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 12:46:18 -0400
Message-ID: <4BFFF31C.9090904@zytor.com>
Date: Fri, 28 May 2010 09:45:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Nicolas Palix <npalix@diku.dk>, Julia Lawall <julia@diku.dk>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 6/17] arch/x86/kernel: Add missing spin_unlock
References: <Pine.LNX.4.64.1005261755260.23743@ask.diku.dk> <20100527111136.GV3266@amd.com> <Pine.LNX.4.64.1005271317180.5422@ask.diku.dk> <201005271342.25619.npalix@diku.dk> <20100528071114.GA3266@amd.com>
In-Reply-To: <20100528071114.GA3266@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2010 12:11 AM, Roedel, Joerg wrote:
> On Thu, May 27, 2010 at 07:42:25AM -0400, Nicolas Palix wrote:
>>> We have submitted and received some feedback on an initial version of 
>>> this, but I'm not completely sure of the current status.
>>
>> You can see the latest feedback we get at
>> http://lkml.org/lkml/2010/5/10/257
>>
>> The initial submission and its comments are at
>> http://lkml.org/lkml/2010/4/26/269
> 
> I've also sent some feedback. Would be cool if you could work the
> feedback in and do a repost asking Andrew to take it. Would be cool to
> have this merged with 2.6.36.
> 

I don't see why scripts that don't *in themselves* change the output
binaries need to wait for .36.  Instead, it would be better to get them
in sooner to make them available to developers in advance of the .36 cycle.

Of course, I'm not Linus, and I don't see him Cc:'d on this, but that
would be the normal rules.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

