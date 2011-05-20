Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812Ab1ETUNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 16:13:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:51031 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935756Ab1ETUNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 16:13:23 -0400
Subject: Re: [git pull] Please pull powerpc.git merge branch
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20110520144653.GH25179@zod.rchland.ibm.com>
Date: Fri, 20 May 2011 15:13:05 -0500
Cc: Richard Cochran <richardcochran@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <EBEB3CA6-696B-4411-8E62-0795A9BC1FD7@kernel.crashing.org>
References: <1305777978.7481.37.camel@pasglop> <20110520132328.GA5785@riccoc20.at.omicron.at> <20110520135845.GG25179@zod.rchland.ibm.com> <20110520143259.GB5785@riccoc20.at.omicron.at> <20110520144653.GH25179@zod.rchland.ibm.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 20, 2011, at 9:46 AM, Josh Boyer wrote:

> On Fri, May 20, 2011 at 04:32:59PM +0200, Richard Cochran wrote:
>> On Fri, May 20, 2011 at 09:58:45AM -0400, Josh Boyer wrote:
>>> On Fri, May 20, 2011 at 03:23:29PM +0200, Richard Cochran wrote:
>>>> When I try to build 'next' (now at 208b3a4c), it does not compile due
>>>> to a change from the following commit.
>>>> 
>>>>> Benjamin Herrenschmidt (1):
>>>>>      powerpc/smp: Make start_secondary_resume available to all CPU variants
>>>> 
>>>> I would appreciate your help in getting this fixed...
>>> 
>>> Could you try the patch below?
>> 
>> Yes, and it both compiles and boots.
> 
> Thanks for testing!
> 
> Ben, can you pull this patch in as-is (fixing up the Subject), or do you
> need me to resubmit it?


Yeah, we need this all so we can send it to stable for 2.6.39.1

- k