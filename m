Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500Ab2DJVUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 17:20:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50908 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2DJVUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 17:20:40 -0400
Message-ID: <4F84A40E.8040907@zytor.com>
Date: Tue, 10 Apr 2012 14:20:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Jim Kukunas <james.t.kukunas@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        linux-raid@vger.kernel.org
Subject: Re: arch/86: AVX RAID5 xor checksumming
References: <1334078551-6859-1-git-send-email-james.t.kukunas@linux.intel.com> <4F846FBC.9060503@zytor.com> <20120411061442.2f839c77@notabene.brown>
In-Reply-To: <20120411061442.2f839c77@notabene.brown>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 01:14 PM, NeilBrown wrote:
>>
>> I think this (and the SSSE3 patches for RAID-6) should go in via the
>> RAID tree.  Neil, do you agree?
> 
> I'm happy to take the SSSE3 RAID-6 patches as they only affect lib/raid6, but
> I felt that this one - being purely in arch/x86 - should probably go via the
> x86 tree.
> However I'm flexible and if you (collectively) are happy with these patches
> going in through my tree, I'll do that.
> 

Go ahead and take them with my Acked-by: -- I think that's easier.

	-hpa

