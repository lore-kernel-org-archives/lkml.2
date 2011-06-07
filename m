Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab1FGTp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:45:26 -0400
Received: from mail.lang.hm ([64.81.33.126]:52996 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab1FGTpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:45:25 -0400
Date: Tue, 7 Jun 2011 12:45:15 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
cc: Theodore Tso <tytso@MIT.EDU>, linux-kernel@vger.kernel.org
Subject: Re: XFS problem in 2.6.32
In-Reply-To: <4DEE2C70.8060301@profihost.ag>
Message-ID: <alpine.DEB.2.02.1106071239530.28905@asgard.lang.hm>
References: <4DEE1D96.6020208@profihost.ag> <6D8DA3D2-D90B-4D82-BDC9-C3F0264A68BF@mit.edu> <4DEE2C70.8060301@profihost.ag>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, Stefan Priebe - Profihost AG wrote:

> Date: Tue, 07 Jun 2011 15:49:36 +0200
>>> So who keeps track on which patches needs to get backported or not? And 
>>> who will backport XFS fixes back to 2.6.32?
>> 
>> An interested kernel developer.   They can become interested because they 
>> personally have the time or interest, or because someone pays them to 
>> become interested.  Support of the stable kernel series is not something 
>> that happens magically, or which is funded by a charity, you know.  That's 
>> why some companies pay $$$ for a supported distribution kernel.

> OK so my thought was totally wrong. I thought the longterm stable releases 
> will still get bugfixed by SGI or whoever wrote the stuff. Sorry for that 
> then. But what is then the idea of a longterm stable?

development and bugfixes are done on the latest kernel, if the problem is 
known to affect old kernels the developers sometimes remember to notify 
the -stable list that this patch is important and needs to be applied to 
older kernels.

whoever the maintainer of the -stable/-longterm tree is (be it an 
individual or a team employeed by some comapny) then looks at the patch 
and considers backporting it (if it's too hard, or to intrusive, they may 
decide not to).

the idea of the lonterm kernels is that organizations need to maintain a 
kernel for a long time due to commitments that they have made (Debian 
doesn't want to change the kernel it ships in a stable version, RedHat 
doesn't want to change the kernel version in a RHEL release, etc), and so 
they publicly announce this so that anyone else wanting to use the same 
kernel version can share in the work (and therefor everyone can benifit 
from each other's work)

David Lang
