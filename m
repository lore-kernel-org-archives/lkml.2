Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab0LMJDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 04:03:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53066 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab0LMJDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 04:03:31 -0500
Message-ID: <74ff92a8c4cf72e42e7559de72e77b52.squirrel@www.firstfloor.org>
In-Reply-To: <4D05E096.6060307@redhat.com>
References: <201012131244.547034648@firstfloor.org>
    <20101212234644.B05DAB27BF@basil.firstfloor.org>
    <4D05DC98.40105@redhat.com>
    <044a861a2279c7e3e328c73e6694fbf3.squirrel@www.firstfloor.org>
    <4D05E096.6060307@redhat.com>
Date: Mon, 13 Dec 2010 10:03:30 +0100
Subject: Re: [PATCH] [104/223] KVM: Write protect memory after slot swap
From: "Andi Kleen" <andi@firstfloor.org>
To: "Avi Kivity" <avi@redhat.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, mst@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/13/2010 10:58 AM, Andi Kleen wrote:
>> >  On 12/13/2010 01:46 AM, Andi Kleen wrote:
>> >>  2.6.35-longterm review patch.  If anyone has any objections, please
>> let
>> >>  me know.
>> >>
>> >
>> >  The way kvm stable updates work, Marcelo and I collect the patches,
>> >  autotest them, and submit them to the stable maintainers.  This way
>> the
>> >  first stable users don't get to be the first ones to actually test
>> the
>> >  new fixes.
>>
>> This should be the (nearly) end point of this process for 2.6.35.
>
> Sorry, I don't follow.  Please elaborate.

People submit the patches to stable@kernel.org
Greg collects them for his stable and long term kernels.
I pick them up them for 2.6.35-longterm. Others for their longterm
kernels.

Then after some time the collected patches get posted for the 48hour
review period, as described in the stable rules. That is what you
saw here. After that they get released.

If you have any objections to this particular patch please let me
know.

-Andi


