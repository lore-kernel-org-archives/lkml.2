Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab1FGWGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:06:07 -0400
Received: from mail.lang.hm ([64.81.33.126]:50620 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757778Ab1FGWGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:06:06 -0400
Date: Tue, 7 Jun 2011 15:05:56 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
cc: Theodore Tso <tytso@MIT.EDU>, linux-kernel@vger.kernel.org
Subject: Re: XFS problem in 2.6.32
In-Reply-To: <4DEE9EDA.90001@profihost.ag>
Message-ID: <alpine.DEB.2.02.1106071504210.28905@asgard.lang.hm>
References: <4DEE1D96.6020208@profihost.ag> <6D8DA3D2-D90B-4D82-BDC9-C3F0264A68BF@mit.edu> <4DEE2C70.8060301@profihost.ag> <alpine.DEB.2.02.1106071239530.28905@asgard.lang.hm> <4DEE9EDA.90001@profihost.ag>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, Stefan Priebe - Profihost AG wrote:

>> whoever the maintainer of the -stable/-longterm tree is (be it an
>> individual or a team employeed by some comapny) then looks at the patch
>> and considers backporting it (if it's too hard, or to intrusive, they
>> may decide not to).
> So i have to contact Greg Kohan from SUSE directly?

if he's the maintainer of the longterm tree, then yes, you would contact 
him or the stable mailing list.

>> the idea of the lonterm kernels is that organizations need to maintain a
>> kernel for a long time due to commitments that they have made (Debian
>> doesn't want to change the kernel it ships in a stable version, RedHat
>> doesn't want to change the kernel version in a RHEL release, etc), and
>> so they publicly announce this so that anyone else wanting to use the
>> same kernel version can share in the work (and therefor everyone can
>> benifit from each other's work)
> That was what i thoght. So a bug like this should get fixed right? Otherwise 
> this makes no sense. Sadly Redhat has ported the fix back in his RHEL 6 
> 2.6.32 kernel but they haven't send the patch to stable / vanilla team.

it depends on how intrusive/disruptive the patch is.

David Lang
