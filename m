Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1ARB2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 20:28:33 -0500
Received: from racecourse.oldelvet.net ([93.93.128.81]:52116 "EHLO
	racecourse.oldelvet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1ARB2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 20:28:32 -0500
Message-ID: <4D34ECBC.2030304@oldelvet.org.uk>
Date: Tue, 18 Jan 2011 01:28:28 +0000
From: Richard Mortimer <richm@oldelvet.org.uk>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: 609371@bugs.debian.org, ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, Jesper.Nilsson@axis.com, jeffm@suse.com
Subject: Re: R_SPARC_13
References: <1295293581.32152.70.camel@duncow>	<20110117.130238.245404805.davem@davemloft.net>	<1295307243.32152.106.camel@duncow> <20110117.163709.15244083.davem@davemloft.net>
In-Reply-To: <20110117.163709.15244083.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18/01/2011 00:37, David Miller wrote:
> From: Richard Mortimer<richm@oldelvet.org.uk>
> Date: Mon, 17 Jan 2011 23:34:03 +0000
>
>> I guess that points towards the binutils linker not doing the correct
>> thing.
>
> Ok, it is in fact doing the correct thing.
>
> I'm really surprised we never hit this before in all of these years
> :-) I guess we've simply never hit this kind of expression in a module
> before.
>
> The issue is that modules aren't a "final link", it's really more like
> an intermediate partial link.
>
> So we do end up seeing the R_SPARC_LO10 + R_SPARC_13 sequences in the
> final module object.
>
> Therefore, we really should handle R_SPARC_13 in the sparc module loader.
>
> Richard, I want you to get full credit for this since you did all of
> the dirty work :-) Would you please cons up a formal patch with commit
> message and signoff for this and I'll push it around?
>
> Thanks a lot!

Will do tomorrow. I'll dust off my git tree.

Regards

Richard
