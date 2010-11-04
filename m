Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0KDHiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 03:38:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:44440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab0KDHiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 03:38:54 -0400
Message-ID: <4CD26270.5050906@kernel.org>
Date: Thu, 04 Nov 2010 08:36:16 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Nathan Lynch <ntl@pobox.com>
CC: Christoph Hellwig <hch@lst.de>, Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kapil@ccs.neu.edu, gene@ccs.neu.edu
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org>  <20101102214706.GA28593@lst.de> <1288835258.6132.56.camel@tp-t61>
In-Reply-To: <1288835258.6132.56.camel@tp-t61>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Nov 2010 07:36:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/04/2010 02:47 AM, Nathan Lynch wrote:
>>   In this case whitelisting the allowed
>> state by requiring special APIs for all I/O (or even just standard
>> APIs as long as they are supposed by the C/R lib you're linked against)
>> is the more pragmatic, and I think faithful aproach.
> 
> I don't think users will go for it.  They'll continue to use dodgy
> out-of-tree kernel modules and/or LD_PRELOAD hacks instead of porting
> their applications to a new library.  I think a C/R library is an
> "ideal" solution, but it's one that nobody would use - especially in
> HPC, unless the library somehow provides better performance.

I hear that there are plans to integrate one of the userland
snapshotting implementations with HPC workload manager.  ISTR the
combination to be condor + dmtcp but not sure.  I think things like
that make a lot of sense.  Scientists writing programs for HPC
clusters already work in given frameworks and what those applications
do and how to recover are pretty well confined/defined.  If you
integrate snapshotting with such frameworks, it becomes pretty easy
for both the admins and users.

I'll talk about other issues in the reply to Oren's email.

Thanks.

-- 
tejun
