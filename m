Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab0KHVGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:06:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:1154 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467Ab0KHVGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:06:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,170,1288594800"; 
   d="scan'208";a="346108534"
Message-ID: <4CD8664C.7090007@linux.intel.com>
Date: Mon, 08 Nov 2010 22:06:20 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: fix apic.h unused but set warnings
References: <1289159606-17417-1-git-send-email-andi@firstfloor.org> <alpine.LFD.2.00.1011081824320.2900@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1011081824320.2900@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/8/2010 8:36 PM, Thomas Gleixner wrote:
> On Sun, 7 Nov 2010, Andi Kleen wrote:
>> [Andrew, can you please put this in your tree for submission.
>> This was submitted some time ago, but x86@ is a blackhole unfortunately and
> You are about to create a blackhole by earning yourself an entry in my
> killfile. I'm really fed up with your sneaky and priggish attacks.

Hi Thomas,

It's unfortunately not the only patch to which this happened. Losing patches
is very common for x86@ based on my experience, the rate seems to be far
far above 50%, more often even higher. I don't know what the problem
is either, but it's very visible to me.

I would certainly not make such a comment without having
sufficient data to back it up.

In fact I don't ping most patches, but had to do it for this one
because the problem is just too noticeable.

Anyways it's easy to avoid such comments too: don't lose patches as often
I would be happy if I didn't need to send any of these reminders. However
at this loss rate you cannot expect nice comments.

-Andi

