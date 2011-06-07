Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab1FGV5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:57:23 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:45355 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966Ab1FGV5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:57:22 -0400
Message-ID: <4DEE9EDA.90001@profihost.ag>
Date: Tue, 07 Jun 2011 23:57:46 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: david@lang.hm
CC: Theodore Tso <tytso@MIT.EDU>, linux-kernel@vger.kernel.org
Subject: Re: XFS problem in 2.6.32
References: <4DEE1D96.6020208@profihost.ag> <6D8DA3D2-D90B-4D82-BDC9-C3F0264A68BF@mit.edu> <4DEE2C70.8060301@profihost.ag> <alpine.DEB.2.02.1106071239530.28905@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.02.1106071239530.28905@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> whoever the maintainer of the -stable/-longterm tree is (be it an
> individual or a team employeed by some comapny) then looks at the patch
> and considers backporting it (if it's too hard, or to intrusive, they
> may decide not to).
So i have to contact Greg Kohan from SUSE directly?

> the idea of the lonterm kernels is that organizations need to maintain a
> kernel for a long time due to commitments that they have made (Debian
> doesn't want to change the kernel it ships in a stable version, RedHat
> doesn't want to change the kernel version in a RHEL release, etc), and
> so they publicly announce this so that anyone else wanting to use the
> same kernel version can share in the work (and therefor everyone can
> benifit from each other's work)
That was what i thoght. So a bug like this should get fixed right? 
Otherwise this makes no sense. Sadly Redhat has ported the fix back in 
his RHEL 6 2.6.32 kernel but they haven't send the patch to stable / 
vanilla team.

Stefan
