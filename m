Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2K2W3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:29:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53184 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823Ab2K2W3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:29:15 -0500
Message-ID: <50B7E17A.2020609@zytor.com>
Date: Thu, 29 Nov 2012 14:28:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Linux Raid <linux-raid@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com> <m2obigf9xa.fsf@firstfloor.org> <50B7CFF8.7010401@zytor.com> <20121129211828.GZ16230@one.firstfloor.org>
In-Reply-To: <20121129211828.GZ16230@one.firstfloor.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 01:18 PM, Andi Kleen wrote:
> 
>> Either way, this implementatin technique was used for the MMX/SSE
>> implementations without any problems for 9 years now.
> 
> It's still wrong.
> 
> Lying to the compiler usually bites you at some point.
> 

It's not lying to the compiler.  It is telling the compiler "do
something that you have no way of knowing about".

It would be lying to the compiler if the compiler was allowed to touch
the FPU state, but it's not.

	-hpa


