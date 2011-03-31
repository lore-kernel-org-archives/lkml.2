Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab1CaGoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:44:07 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:46052 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab1CaGoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:44:05 -0400
Message-ID: <4D9422B0.2020003@msgid.tls.msk.ru>
Date: Thu, 31 Mar 2011 10:44:00 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mijinlong@cn.fujitsu.com, ak@linux.intel.com, bfields@redhat.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: Re: [PATCH] [232/275] nfsd: wrong index used in inner loop
References: <20110330203.501921634@firstfloor.org> <20110330210757.F3D223E1A05@tassilo.jf.intel.com> <4D93A6F4.60206@msgid.tls.msk.ru> <4D93A8F9.2080407@msgid.tls.msk.ru> <20110330233328.GH21838@one.firstfloor.org>
In-Reply-To: <20110330233328.GH21838@one.firstfloor.org>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

31.03.2011 03:33, Andi Kleen wrote:
>> Doh, so this 232/275 basically reverts that 180 and makes
>> other change down the line, but keeps the subject intact.
>> Especially useful that the two patches are so far away
>> from each other (more than 50 patches in-between).
>> Confusing :)
>>
>> So both are actually needed, apparently.
> 
> Sorry about that -- i ended up grabbing those from .32 and since
> there were multiple releases in sequence it ended up this way.

It's definitely not your fault -- second patch should be
named differently (since it does something else) but it's
not.

> I can collapse the two patches.

Just be careful they don't end in the same _file_.  In
the gregkh's stable-queue repository each patch is keept
in a separate file named after the subject line, so that
means just that - the same file.

> Are the leftover hunks after that good?

I remember original discussion when first patch has been
posted (was fun to read the original code), but I missed
second half of it.  So I re-read it and found the second
part now, all is ok with it and with the resulting two-
patch solution, except of the possible "patch name" clash,
which may only when organizing patches in a plain directory.

Anyway, that's a good story I think, and the conclusion is -
please name your patches correctly :)

Thank you!

/mjt
